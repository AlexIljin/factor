! Copyright (C) 2017 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax
combinators system ;
IN: checksums.argon2

<< "argon2" {
    { [ os windows? ] [ "argon2.dll" ] }
    { [ os macosx? ] [ "libargon2.dylib" ] }
    { [ os unix? ] [ "libargon2.so" ] }
} cond cdecl add-library >>

LIBRARY: argon2

FUNCTION: int argon2i_hash_raw (
    uint32_t t_cost, uint32_t m_cost, uint32_t parallelism,
    void* pwd, size_t pwdlen,
    void* salt, size_t saltlen,
    void* hash, size_t hashlen )
