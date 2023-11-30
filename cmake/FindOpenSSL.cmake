if(QNX)
    set(OPENSSL_LIBRARIES ${QNX_TARGET}/${CPUVARDIR}/usr/lib/libssl.so
        ${QNX_TARGET}/${CPUVARDIR}/usr/lib/libcrypto.so)
endif()
