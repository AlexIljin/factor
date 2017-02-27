! Copyright (C) 2017 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax
classes.struct combinators system ;
IN: argon2b

<< "argon2b" {
    { [ os windows? ] [ "argon2b.dll" ] }
    { [ os macosx? ] [ "libargon2b.dylib" ] }
    { [ os unix? ] [ "libargon2b.so" ] }
} cond cdecl add-library >>

LIBRARY: argon2b

FUNCTION: int argon2i_hash_raw (
    uint32_t t_cost, uint32_t m_cost, uint32_t parallelism,
    void* pwd, size_t pwdlen,
    void* salt, size_t saltlen,
    void* hash, size_t hashlen )

CONSTANT: BLAKE2B_OUTBYTES 64
CONSTANT: BLAKE2B_BLOCKBYTES 128

STRUCT: blake2b_state
    { h uint64_t[8] }
    { t uint64_t[2] }
    { f uint64_t[2] }
    { buf uint8_t[BLAKE2B_BLOCKBYTES] }
    { buflen uint32_t }
    { outlen uint32_t }
    { last_node uint8_t } ;

FUNCTION: int blake2b_init ( blake2b_state* S, size_t outlen )
FUNCTION: int blake2b_init_key ( blake2b_state* S, size_t outlen,
    void* key, size_t keylen )
FUNCTION: int blake2b_update ( blake2b_state* S, void* in, size_t inlen )
FUNCTION: int blake2b_final ( blake2b_state* S, void* out, size_t outlen )

FUNCTION: int blake2b ( void* out, size_t outlen,
    void* in, size_t inlen,
    void* key, size_t keylen )
