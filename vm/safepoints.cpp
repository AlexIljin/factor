#include "master.hpp"

namespace factor {

void safepoint_state::enqueue_fep(factor_vm* parent) volatile {
  if (parent->fep_p)
    fatal_error("Low-level debugger interrupted", 0);
  atomic::store(&fep_p, true);
  parent->code->set_safepoint_guard(true);
}

void safepoint_state::enqueue_samples(factor_vm* parent,
                                      cell samples,
                                      cell pc,
                                      bool foreign_thread_p) volatile {

  if (!atomic::load(&parent->sampling_profiler_p))
    return;
  atomic::fetch_add(&sample_counts.sample_count, samples);

  if (foreign_thread_p)
    atomic::fetch_add(&sample_counts.foreign_thread_sample_count, samples);
  else {
    if (atomic::load(&parent->current_gc_p))
      atomic::fetch_add(&sample_counts.gc_sample_count, samples);
    if (atomic::load(&parent->current_jit_count) > 0)
      atomic::fetch_add(&sample_counts.jit_sample_count, samples);
    if (!parent->code->seg->in_segment_p(pc))
      atomic::fetch_add(&sample_counts.foreign_sample_count, samples);
  }
  parent->code->set_safepoint_guard(true);
}

void safepoint_state::handle_safepoint(factor_vm* parent, cell pc) volatile {
  parent->code->set_safepoint_guard(false);
  parent->faulting_p = false;

  if (atomic::load(&fep_p)) {
    atomic::store(&fep_p, false);
    if (atomic::load(&parent->sampling_profiler_p))
      parent->end_sampling_profiler();
    std::cout << "Interrupted\n";
    if (parent->stop_on_ctrl_break) {
      // Ctrl-Break throws an exception, interrupting the main thread, same
      // as the "t" command in the factorbug debugger. But for Ctrl-Break to
      // work we don't require the debugger to be activated, or even enabled.
      parent->general_error(ERROR_INTERRUPT, false_object, false_object);
      FACTOR_ASSERT(false);
    }
    parent->factorbug();
  } else if (atomic::load(&parent->sampling_profiler_p)) {
    FACTOR_ASSERT(parent->code->seg->in_segment_p(pc));
    code_block* block = parent->code->code_block_for_address(pc);
    bool prolog_p = block->entry_point() == pc;

    parent->record_sample(prolog_p);
  }
}

}
