package com.turismo.utils;

import java.security.SecureRandom;

public class BCrypt {
    private static final int GENCRYPT_ITERS = 16;
    private static final int BCRYPT_SALT_LEN = 16;
    private static final int BLOWFISH_NUM_ROUNDS = 16;

    private static final int P_orig[] = {
        0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344,
        0xa4093822, 0x299f31d0, 0x082efa98, 0xec4e6c89,
        0x452821e6, 0x38d01377, 0xbe5466cf, 0x34e90c6c,
        0xc0ac29b7, 0xc97c50dd, 0x3f84d5b5, 0xb5470917,
        0x9216d5d9, 0x8979fb1b
    };

    private static final int S_orig[] = {
        0xd1310ba6, 0x98dfb5ac, 0x2ffd72db, 0xd01adfb7,
        0xb8e1afed, 0x6a267e96, 0xba7c9045, 0xf12c7f99,
        0x24a19947, 0xb3916cf7, 0x0801f2e2, 0x858efc16,
        0x636920d8, 0x71574e69, 0xa458fea3, 0xf4933d7e,
        0x0d95748f, 0x728eb658, 0x718bcd58, 0x82154aee,
        0x7b54a41d, 0xc25a59b5, 0x9c30d539, 0x2af26013,
        0xc5d1b023, 0x286085f0, 0xca417918, 0xb8db38ef,
        0x8e79dcb0, 0x603a180e, 0x6c9e0e8b, 0xb01e8a3e,
        0xd71577c1, 0xbd314b27, 0x78af2fda, 0x55605c60,
        0xe65525f3, 0xaa55ab94, 0x57489862, 0x63e81440,
        0x55ca396a, 0x2aab10b6, 0xb4cc5c34, 0x1141e8ce,
        0xa15486af, 0x7c72e993, 0xb3ee1411, 0x636fbc2a,
        0x2ba9c55d, 0x741831f6, 0xce5c3e16, 0x9b87931e,
        0xafd6ba33, 0x6c24cf5c, 0x7a325381, 0x28958677,
        0x3b8f4898, 0x6b4bb9af, 0xc4bfe81b, 0x66282193,
        0x61d809cc, 0xfb21a991, 0x487cac60, 0x5dec8032,
        0xef845d5d, 0xe98575b1, 0xdc262302, 0xeb651b88,
        0x23893e81, 0xd396acc5, 0x0f6d6ff3, 0x83f44239,
        0x2e0b4482, 0xa4842004, 0x69c8f04a, 0x9e1f9b5e,
        0x21c66842, 0xf6e96c9a, 0x670c9c61, 0xabd388f0,
        0x6a51a0d2, 0xd8542f68, 0x960fa728, 0xab5133a3,
        0x6eef0b6c, 0x137a3be4, 0xba3bf050, 0x7efb2bbe,
        0x9b1147b7, 0xe66bfb96, 0x61072d5e, 0x9ec21785,
        0x6c299560, 0x8304766e, 0x10336248, 0xd314b2ab,
        0x590752d4, 0xee6d5a0a, 0x7d2f7add, 0xb3e5bf0a,
        0x43e0727e, 0x1161c00f, 0xf0bfe188, 0x8f1516b2,
        0x4025e372, 0x742ab559, 0xab7ac743, 0x91b299e6,
        0x8645d90c, 0x281b1a2f, 0x5b20f002, 0x41e64a4b,
        0x4ffc162f, 0x56488391, 0xe299eef4, 0x36dd0071,
        0xf07361e2, 0x6c13c0eb, 0xbbf50183, 0x2bf4c954,
        0xb6956557, 0x863a73c0, 0xf2e16acd, 0x7507747f,
        0xae123456, 0xd003f508, 0x2f356077, 0xbc447920,
        0x4f1b4647, 0xac697aac, 0x4da07f6b, 0xf7bcb708,
        0xca11d026, 0xd805faad, 0x57724129, 0x30c12007,
        0x550a8299, 0xa65525c3, 0x42c0a897, 0xc3de0ff3,
        0x3da080f3, 0x29f12244, 0x0f01e130, 0xcc89e821,
        0xabfb3a99, 0xcd19f6a5, 0xa629d610, 0xb64e1b83,
        0xa779f62e, 0x46f3e2f8, 0x5c4e0401, 0x8d4897a2,
        0x455da545, 0x34ee04cb, 0x40d33235, 0x479d45ac,
        0xa7455ab8, 0xd888e4f1, 0xb99f0645, 0x40181402,
        0x55f4d2c7, 0x048b2368, 0xb0f39528, 0x2b05d94f,
        0x92dd4e3b, 0x9d5b1661, 0xa1f42a13, 0x4c0092d6,
        0x32373719, 0xbce07e2c, 0x1e737fe0, 0x4a1f4852,
        0xb99d7fbc, 0x534d0269, 0xe14e45e2, 0x6eac02c1,
        0x154ca7b7, 0x470cf994, 0x12c61908, 0xfe7033f9,
        0x826543ca, 0x466a39d4, 0xb89c0f82, 0xc1f1d64b,
        0x42d15477, 0x853f65b9, 0x2a5426b0, 0xee63142a,
        0x6e074c82, 0x4b38128b, 0x30f7537e, 0xbef90dae,
        0x4e08240b, 0x91e2b0c0, 0x7bce01e2, 0x4fe0d642,
        0x4d6730e3, 0x98b1fe6b, 0x76aa96f0, 0xd1b1c79e,
        0x783b4c1e, 0x47a094e0, 0x5886e1d7, 0x70c41b99,
        0x62426dd7, 0xbf631e1b, 0x12bfb8a8, 0x03e44327,
        0x238e7e6f, 0xbf53e0a9, 0x5c40555d, 0xd7494f10,
        0x3870f3f9, 0xd2fc0973, 0x2ecb1a28, 0x8633149a,
        0x59508494, 0x103a674e, 0xadc09338, 0x4221ec12,
        0xe08d341e, 0x73bca0ae, 0x3d476f72, 0x0f51f9b1,
        0x6129438e, 0x52a9f03c, 0xbece622e, 0x1a61e94f,
        0xd0e3b4ec, 0x39ec3563, 0x44860fbe, 0xbe9a4ff0,
        0x2030f44e, 0x3c651941, 0xec343fcd, 0x3d115f93,
        0x477ac0b4, 0xa6078420, 0x5764a3a8, 0x6a7e9040,
        0xca0a7141, 0x417f201d, 0xd0ecac0f, 0x8537728e,
        0xf2bf1b59, 0x73436820, 0x6ee67668, 0x429153d6,
        0x55bb0021, 0x0be257f0, 0x167860d7, 0x7b805aee,
        0xfbc1f73b, 0xbcd6a431, 0x5bf54e93, 0x6c05035f,
        0x3564d75e, 0xded4c57e, 0x85b7a9fb, 0x3fa06235,
        0xf07fefc0, 0xec60e10d, 0x3a4506d4, 0x2fe31610,
        0x49a0b025, 0x8fed48b8, 0x2a29805d, 0xc9fb494b,
        0x7d502f65, 0xd130210f, 0x6c5331d2, 0xb4d14239,
        0x45cf7042, 0x06121494, 0x8ebd523d, 0x3e520ec6,
        0x1773e203, 0xa0857249, 0xb3c5be83, 0x0c469d93,
        0xb4510b6a, 0xa00f6fed, 0xb05388c3, 0xb3667a3e,
        0x47d0e1e1, 0x12f61fc1, 0x4b2a637a, 0x832a36ad,
        0xc743505b, 0xbca09e59, 0xe4fe09d2, 0x9804f5ff,
        0x9fcb420b, 0x99bd9368, 0x77d0e070, 0x42a6b4d9,
        0x541e8d80, 0xecb29a42, 0x4d150a26, 0x410ae1a4,
        0x4bf334fb, 0x78841234, 0x16a5126d, 0xeb55cb83,
        0x599b54c6, 0xa691f993, 0x544059ff, 0x30f77249,
        0x4097c846, 0xe79b0de3, 0x42417fef, 0x4f3265cb,
        0xa51e4796, 0x5ac11064, 0x2e1b10fd, 0x26482381,
        0x6080f032, 0xdc7f7f89, 0xd360da1e, 0x46495a3d,
        0x2a0ee880, 0x8476d020, 0x5ad77a3c, 0x23f2f354,
        0x391e3232, 0xa5ab3453, 0x3a50d608, 0x3106f340,
        0xd0d3057d, 0x20a80d67, 0x9962184d, 0x45ac3673,
        0x6cf841e8, 0xa616c2fd, 0x0e26982b, 0xf53e65b8,
        0xbe14e731, 0x5d4e515d, 0x84570241, 0xe14f6746,
        0x501e00a3, 0x6414be39, 0x4a412954, 0x6a94d1fb,
        0x78f4c599, 0x15176ce7, 0xa6c6f21f, 0x79441f19,
        0x38606993, 0x4e56c073, 0x42e23274, 0x80ba023f,
        0x72808442, 0x535d060c, 0x0eb3e74d, 0xefb213b2,
        0x769e61cd, 0x4d54e493, 0x8773b4d4, 0x89a01660,
        0x283209b0, 0x29feedb1, 0x20cf594e, 0x2649b5a0,
        0x72cf5a82, 0xd7872f42, 0x386324b4, 0x80bf824e,
        0x3104180f, 0x7f5f0017, 0x43b084d3, 0x1fe24220,
        0x429b9e13, 0xb4791760, 0x128a1438, 0xb28386f0,
        0x451b1444, 0x164c2482, 0x5d2fef13, 0x543c1b58,
        0x49dd2149, 0x4742f205, 0x4b7e7314, 0x1a95450b,
        0x3b664d08, 0xbf631e1c, 0x467e22c7, 0x4a4e7240,
        0xdb30eb57, 0x4f31d28e, 0x67a9c86e, 0x0b010b27,
        0x6a24eb82, 0xf52c6014, 0x86be0d01, 0x4a246f2e,
        0xa3067172, 0x01a4a808, 0x4000f07e, 0x857777a4,
        0x524249cc, 0xab0540e8, 0x43297ab7, 0x8876d094,
        0x0c6c65b0, 0x4be31610, 0xc550c956, 0xf72c572b,
        0x4e138322, 0x61405102, 0x84295b5a, 0x83142207,
        0x4d98be07, 0x7370428b, 0x2f8b2322, 0x4ae374b5,
        0x011f125e, 0x2d8e3245, 0xd5ce70cb, 0x0510686f,
        0x07469904, 0x5380e222, 0x8d5d4c32, 0x70505a4e,
        0x5f1e05ee, 0x530175bc, 0x5380521e, 0x864f6010,
        0x428a2b97, 0x9e1f0b01, 0x83301c02, 0x76f43b84,
        0x8032164b, 0x53b7064a, 0x4e543028, 0xdf463e23,
        0x41735194, 0x1b2c4e30, 0x8b25059c, 0x547a0649,
        0x2e1649ec, 0x4a6da65d, 0xd4011df8, 0x256f1b02,
        0x732e434f, 0xdac95604, 0x4970e0fe, 0x8d493fe9,
        0x496c7c6e, 0x64703d85, 0xfa224f41, 0x25e65ce7,
        0xc2c44ce1, 0xbabee8e4, 0x3910f321, 0xdc3194e2,
        0x40971b7d, 0x8f4b0e7f, 0x42885994, 0x2a01f112,
        0x1ca093f3, 0x4296fa22, 0xa8920102, 0xecd30709,
        0x674f6d1b, 0x46b0e0e0, 0xd54765bc, 0x43fb1b57,
        0x1b4a4758, 0x76ac0c3e, 0x6efb7b45, 0x5286085f,
        0x4331026e, 0xacb3056d, 0xf00a45e1, 0xd03e4d83,
        0x49511329, 0xa407f890, 0x47d9f672, 0x5ac13018,
        0xca02809f, 0x679cf79b, 0x8f2cbe77, 0x494a0884,
        0x5be3b055, 0x4772e77b, 0x3064805f, 0x01da2507,
        0x8d5c4380, 0x8e04207a, 0x8051805e, 0x4b702d1e,
        0x70c3f021, 0x0eb1e103, 0xf20213f6, 0x299e2409,
        0x10fc2fb0, 0x00850a4d, 0x4e0ddbb0, 0x800e1532,
        0x47a74051, 0x17c343d2, 0x2316c80d, 0x60f7769f,
        0x1597e000, 0x36b08311, 0x934057cb, 0x42839163,
        0x4e118211, 0x48b22021, 0x5b770277, 0x80f092b6,
        0x402356cf, 0xd2bff980, 0x4388b4f4, 0xe5e1a0c9,
        0x3fe30883, 0xb112cacb, 0x4c000414, 0xaf616161,
        0x0e46fb79, 0x864e17fe, 0x59c53099, 0x65cca4a2,
        0x3ac5f10e, 0xdfe9e50e, 0xbc840e5d, 0x18fe044e,
        0xdfa50ef8, 0xe00b0d09, 0xe14742d1, 0xb826445f,
        0x4b7f8c05, 0x6be5e00a, 0x3634980d, 0x294c7fe0,
        0xd03d1248, 0xb5052214, 0x45286085, 0x234102d4,
        0xbe0e0410, 0x36942e58, 0x4c6f44c0, 0xc13309f1,
        0xe463b2a4, 0x7bbb9071, 0x4470938f, 0x4944d0f8,
        0x428e8066, 0xa3035b0f, 0x0e8d42ef, 0x1b0f4358,
        0x479a22f0, 0x8340e4e9, 0xdba7b690, 0x5b624a0e,
        0xc031d9f0, 0x1c201e3d, 0x6ee10ef3, 0x4e708f68,
        0x708e063a, 0x4562708a, 0x32a6ce4b, 0x3ee21551,
        0x4b208208, 0x56b1fe4f, 0xd7217c04, 0x6297432e,
        0xac6f0079, 0x22c63079, 0x640ee09e, 0x722fe9a2,
        0x83e2041e, 0x30432eef, 0x45fe04dc, 0xe24ec112,
        0x0f00100f, 0x40d5426d, 0x0c12fe5e, 0x8285c4f8
    };

    private static final char base64_code[] = {
        '.', '/', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
        'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
        'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
        'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5',
        '6', '7', '8', '9'
    };

    private static final byte index_64[] = {
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  1,
        54, 55, 56, 57, 58, 59, 60, 61, 62, 63, -1, -1, -1, -1, -1, -1,
        -1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, -1, -1, -1, -1,
        -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
        43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, -1, -1, -1, -1, -1
    };

    private static final int bf_crypt_ciphertext[] = {
        0x4f727068, 0x65616e42, 0x65686f6c,
        0x64657253, 0x63727970, 0x7442696e
    };

    private int P[];
    private int S[];

    private static void encode_base64(byte d[], int len, StringBuilder rs) {
        int off = 0;
        int c1, c2;

        if (len <= 0 || len > d.length)
            throw new IllegalArgumentException("Invalid len");

        while (off < len) {
            c1 = (d[off++] & 0xff);
            rs.append(base64_code[(c1 >> 2) & 0x3f]);
            c1 = (c1 & 0x03) << 4;
            if (off >= len) {
                rs.append(base64_code[c1 & 0x3f]);
                break;
            }
            c2 = (d[off++] & 0xff);
            c1 |= (c2 >> 4) & 0x0f;
            rs.append(base64_code[c1 & 0x3f]);
            c1 = (c2 & 0x0f) << 2;
            if (off >= len) {
                rs.append(base64_code[c1 & 0x3f]);
                break;
            }
            c2 = (d[off++] & 0xff);
            c1 |= (c2 >> 6) & 0x03;
            rs.append(base64_code[c1 & 0x3f]);
            rs.append(base64_code[c2 & 0x3f]);
        }
    }

    private static byte char64(char x) {
        if ((int)x < 0 || (int)x > index_64.length)
            return -1;
        return index_64[(int)x];
    }

    private static byte[] decode_base64(String s, int maxolen) {
        StringBuilder rs = new StringBuilder();
        int off = 0, slen = s.length(), olen = 0;
        byte ret[];
        byte c1, c2, c3, c4, o;

        while (off < slen - 1 && olen < maxolen) {
            c1 = char64(s.charAt(off++));
            c2 = char64(s.charAt(off++));
            if (c1 == -1 || c2 == -1)
                break;
            o = (byte)(c1 << 2);
            o |= (byte)((c2 & 0x30) >> 4);
            rs.append((char)o);
            if (++olen >= maxolen || off >= slen)
                break;
            c3 = char64(s.charAt(off++));
            if (c3 == -1)
                break;
            o = (byte)((c2 & 0x0f) << 4);
            o |= (byte)((c3 & 0x3c) >> 2);
            rs.append((char)o);
            if (++olen >= maxolen || off >= slen)
                break;
            c4 = char64(s.charAt(off++));
            o = (byte)((c3 & 0x03) << 6);
            o |= c4;
            rs.append((char)o);
            olen++;
        }

        ret = new byte[olen];
        for (off = 0; off < olen; off++)
            ret[off] = (byte)rs.charAt(off);
        return ret;
    }

    private int streamtou32(byte data[], int offp[]) {
        int i;
        int v = 0;
        int off = offp[0];

        for (i = 0; i < 4; i++) {
            v <<= 8;
            v |= (data[off] & 0xff);
            off = (off + 1) % data.length;
        }
        offp[0] = off;
        return v;
    }

    private void init_key() {
        P = (int[])P_orig.clone();
        S = (int[])S_orig.clone();
    }

    private void encipher(int lr[], int off) {
        int i, n, l = lr[off], r = lr[off + 1];

        l ^= P[0];
        for (i = 0; i <= BLOWFISH_NUM_ROUNDS - 2;) {
            n = S[(l >> 24) & 0xff];
            n += S[0x100 | ((l >> 16) & 0xff)];
            n ^= S[0x200 | ((l >> 8) & 0xff)];
            n += S[0x300 | (l & 0xff)];
            r ^= n ^ P[++i];
            n = S[(r >> 24) & 0xff];
            n += S[0x100 | ((r >> 16) & 0xff)];
            n ^= S[0x200 | ((r >> 8) & 0xff)];
            n += S[0x300 | (r & 0xff)];
            l ^= n ^ P[++i];
        }
        lr[off] = r ^ P[BLOWFISH_NUM_ROUNDS + 1];
        lr[off + 1] = l;
    }

    private void ekskey(byte data[], byte key[]) {
        int i, j, off = 0;
        int lr[] = new int[2];
        int poff[] = new int[1];

        for (i = 0; i < P.length; i++)
            P[i] ^= streamtou32(key, poff);

        poff[0] = 0;
        for (i = 0; i < P.length; i += 2) {
            lr[0] ^= streamtou32(data, poff);
            lr[1] ^= streamtou32(data, poff);
            encipher(lr, 0);
            P[i] = lr[0];
            P[i + 1] = lr[1];
        }

        for (i = 0; i < S.length; i += 2) {
            lr[0] ^= streamtou32(data, poff);
            lr[1] ^= streamtou32(data, poff);
            encipher(lr, 0);
            S[i] = lr[0];
            S[i + 1] = lr[1];
        }
    }

    private byte[] crypt_raw(byte password[], byte salt[], int log_rounds, int cdata[]) {
        int rounds, i, j;
        int clen = cdata.length;
        byte ret[];

        if (log_rounds < 4 || log_rounds > 31)
            throw new IllegalArgumentException("Bad number of rounds");
        rounds = 1 << log_rounds;
        if (salt.length != BCRYPT_SALT_LEN)
            throw new IllegalArgumentException("Bad salt length");

        init_key();
        ekskey(salt, password);
        for (i = 0; i < rounds; i++) {
            key(password);
            key(salt);
        }

        for (i = 0; i < 64; i++) {
            for (j = 0; j < (clen >> 1); j++)
                encipher(cdata, j << 1);
        }

        ret = new byte[clen * 4];
        for (i = 0, j = 0; i < clen; i++) {
            ret[j++] = (byte)((cdata[i] >> 24) & 0xff);
            ret[j++] = (byte)((cdata[i] >> 16) & 0xff);
            ret[j++] = (byte)((cdata[i] >> 8) & 0xff);
            ret[j++] = (byte)(cdata[i] & 0xff);
        }
        return ret;
    }

    private void key(byte key[]) {
        int i, j, off = 0;
        int lr[] = new int[2];
        int poff[] = new int[1];

        for (i = 0; i < P.length; i++)
            P[i] ^= streamtou32(key, poff);

        poff[0] = 0;
        for (i = 0; i < P.length; i += 2) {
            encipher(lr, 0);
            P[i] = lr[0];
            P[i + 1] = lr[1];
        }

        for (i = 0; i < S.length; i += 2) {
            encipher(lr, 0);
            S[i] = lr[0];
            S[i + 1] = lr[1];
        }
    }

    public static String hashpw(String password, String salt) {
        BCrypt B;
        String real_salt;
        byte passwordb[], saltb[], hashed[];
        char minor = (char)0;
        int rounds, off = 0;
        StringBuilder rs = new StringBuilder();

        if (salt == null)
            throw new IllegalArgumentException("salt cannot be null");

        int len = salt.length();

        if (len < 28)
            throw new IllegalArgumentException("Invalid salt");
        if (salt.charAt(0) != '$' || salt.charAt(1) != '2')
            throw new IllegalArgumentException("Invalid salt version");
        if (salt.charAt(2) == '$')
            off = 3;
        else {
            minor = salt.charAt(2);
            if ((minor != 'a' && minor != 'y' && minor != 'b') || salt.charAt(3) != '$')
                throw new IllegalArgumentException("Invalid salt revision");
            off = 4;
        }

        if (salt.charAt(off + 2) > '$')
            throw new IllegalArgumentException("Missing salt rounds");
        rounds = Integer.parseInt(salt.substring(off, off + 2));

        real_salt = salt.substring(off + 3, off + 25);
        try {
            passwordb = (password + (minor >= 'a' ? "\0" : "")).getBytes("UTF-8");
        } catch (java.io.UnsupportedEncodingException uee) {
            throw new AssertionError("UTF-8 not supported");
        }

        saltb = decode_base64(real_salt, BCRYPT_SALT_LEN);

        B = new BCrypt();
        hashed = B.crypt_raw(passwordb, saltb, rounds, (int[])bf_crypt_ciphertext.clone());

        rs.append("$2a$");
        if (rounds < 10)
            rs.append("0");
        rs.append(rounds);
        rs.append("$");
        encode_base64(saltb, saltb.length, rs);
        encode_base64(hashed, bf_crypt_ciphertext.length * 4 - 1, rs);
        return rs.toString();
    }

    public static String gensalt(int log_rounds, SecureRandom random) {
        if (log_rounds < 4 || log_rounds > 31)
            throw new IllegalArgumentException("Bad number of rounds");
        byte rnd[] = new byte[BCRYPT_SALT_LEN];
        random.nextBytes(rnd);
        StringBuilder rs = new StringBuilder();
        rs.append("$2a$");
        if (log_rounds < 10)
            rs.append("0");
        rs.append(log_rounds);
        rs.append("$");
        encode_base64(rnd, rnd.length, rs);
        return rs.toString();
    }

    public static String gensalt(int log_rounds) {
        return gensalt(log_rounds, new SecureRandom());
    }

    public static String gensalt() {
        return gensalt(GENCRYPT_ITERS);
    }

    public static boolean checkpw(String plaintext, String hashed) {
        if (hashed == null || hashed.length() < 28)
            return false;
        try {
            return equalsNoEarlyBreak(hashed, hashpw(plaintext, hashed));
        } catch (Exception e) {
            return false;
        }
    }

    private static boolean equalsNoEarlyBreak(String a, String b) {
        char[] ca = a.toCharArray();
        char[] cb = b.toCharArray();
        int diff = ca.length ^ cb.length;
        for (int i = 0; i < ca.length && i < cb.length; i++) {
            diff |= ca[i] ^ cb[i];
        }
        return diff == 0;
    }
}
