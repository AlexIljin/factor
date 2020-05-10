! Copyright (C) 2020 Alexander Ilin.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences sodium sqrl.enscrypt tools.test ;
IN: sqrl.enscrypt.tests

! https://github.com/sqrldev/sqrl-test-vectors/blob/master/vectors/enscrypt-vectors.txt
CONSTANT: test-vectors {
    { "qOpipuG_0g5CdQEVlTB6owJkXBgBYA71zXm_nYhNkRw" "" "" 1 }
    { "NBTyp7SXGaJuw1eV0LzvcgOz3-jW6-PR4AIHhdimr_U" "" "" 2 }
    { "AHJHCHgBuNd8Lkfm2mdZ6mPjjIG2R0L1aerQBedf4GA" "" "" 10 }
    { "DO0jaHNPEiS6EjHDZbUwJxzXETREdFHBKZOgAoIzM8M" "" "" 40 }
    { "KbvLlZe22laDj_xTGU9kj1OA1-3xj2GQT2T8tZ-1B9U" "" "NaCl" 1 }
    { "4cK0OFYxBAi4rPctffFay8s_mPp_0LcYySDIEoJuQC0" "" "NaCl" 2 }
    { "MocZLpLXucMOreRgUMPFYDbCn-3_vjT7GoIKh-s0PyQ" "" "NaCl" 10 }
    { "GFHFdwpC98x3rNY6UETc1Yh7-CetJ6En20b8N0IgeU8" "" "NaCl" 40 }
    { "l-BjQqXezaWpdzcVVDu1dCFTnloAy_D2jrNoIPtJvw0" "" "SodiumChloride" 1 }
    { "A_peZYo0wLC6zqEPcZgVCFrOfi1Dqbo3-7JymlKLwTg" "" "SodiumChloride" 2 }
    { "42pXrm-mUIDtQ03rk7fzzq5U51kcS4HVi6C8FA4OrPA" "" "SodiumChloride" 10 }
    { "9YweH54M1KpthHOaW5FTIPvNERNdPD2ejD9Y1dg8vc8" "" "SodiumChloride" 40 }
    { "vgpRhA4OFcB41-kv1ssuiT2dKFxAfMV0AGi4UnXLvZE" "" "VQjbCSbb2q1t4" 1 }
    { "IT4hc5cxiN82k9U3q4H3xP3paqdaaM2xISUmzdNWKas" "" "VQjbCSbb2q1t4" 2 }
    { "I9kPvEp1O49I-Xc_c4lqy8zgZ2Y9a08j4x91UrwCua8" "" "VQjbCSbb2q1t4" 10 }
    { "g6xSFPLjPYLdfJBPbHnCZMu5bvMERBQNp7H9t3u9Muo" "" "VQjbCSbb2q1t4" 40 }
    { "SRk9aDN3fBRpN0GELENEmo_TZfGA6oCrtKyRhixFjdE" "password" "" 1 }
    { "Kev9B60uINuzIpX6fidMEnVCyA11hlEmGYEGemoCoso" "password" "" 2 }
    { "CM3lVyQUpvbYOogeUvNo6kSJMCB7MJMZN5MEMWtE4Fc" "password" "" 10 }
    { "jojzZDX00XtjaOgbpzIK2jSkGRtCvKmKtG5DYukw5Bs" "password" "" 40 }
    { "kAivDuomSDs-Ip0m2lEnfeTTrKtYyDWzS5MD_yL1Rqg" "password" "NaCl" 1 }
    { "3YOcNyXC7-a_7RG4Fd2pKRotFwBpc0JbNRQVkxjwW7c" "password" "NaCl" 2 }
    { "FfpIQRMRvH8bXRObdzjkmIJnwaBKTZOgMxYdr67BgPQ" "password" "NaCl" 10 }
    { "Ei_l-O_Isl4No6fsDPSQeQ9ab2IaemqfCUP8qQLnvj0" "password" "NaCl" 40 }
    { "1x7_ToBf2rOsdJy4feRa-KvGgsVKtwJ8D80_9ePLp6o" "password" "SodiumChloride" 1 }
    { "AVmLjrJku7PBq6rxQDmbzSv9YsqVriZ7_Y-ZT1ZO-zU" "password" "SodiumChloride" 2 }
    { "X6NK5xFZlVEJuj6KLs7OoHjAd_zklVSJ59Bt0nVcDQ8" "password" "SodiumChloride" 10 }
    { "nQZOPPNgrVtI9obdE-mRO8TxMQrcFoCEBWLcPH9OPMY" "password" "SodiumChloride" 40 }
    { "BeJEZWEmfnhWa9TqujgL0uX3-zK0obkmttHfwpW_a9k" "password" "VQjbCSbb2q1t4" 1 }
    { "a5-PqzkPH5IF5KlfsQFNNNLY9wP3qAWQSazInkcM18U" "password" "VQjbCSbb2q1t4" 2 }
    { "pd7bz7TlEfFn_CrmdCRSXwwNU5ty7lWk00DPQP6oxrk" "password" "VQjbCSbb2q1t4" 10 }
    { "QKGfNlKIHjbQzRI9ViVDoYi8xOcSIOCbAtkl7fBoeNA" "password" "VQjbCSbb2q1t4" 40 }
    { "Iu_KNZcwF1JEV-ogu0scEmEnbTx4uUlqOimPVpXZtOY" "LetMeIn" "" 1 }
    { "qXfUYi50kd9O0fCFE_U7Z9hOkl07XDtsQ0WStrncsyM" "LetMeIn" "" 2 }
    { "ypBuobkLkGNLe9hUWu7kyyU3hXlGyqwicceH4vcxTWM" "LetMeIn" "" 10 }
    { "fU-eZOVrvYtfnjyuVjDJwW7FIDr4kSudElwujU-ooB0" "LetMeIn" "" 40 }
    { "SAjAif2p2G9ghWoGJqQpg-cqtO1QYq2H_oVk04TtW8A" "LetMeIn" "NaCl" 1 }
    { "i6Ai-z56GbomoTYc0EzEWQldF3B-PpVM5hdNwmPpCmA" "LetMeIn" "NaCl" 2 }
    { "yjeIc1xFdSXUOE-fRSsgSSeyC8IfZDH5hqwvluJDn_U" "LetMeIn" "NaCl" 10 }
    { "roQR4B4SCVEFBJFgYb3WOyNlQurLTgHcRhNmC7CEZf8" "LetMeIn" "NaCl" 40 }
    { "hNRTP9gAdNa9P0V59ntH9WyMQJ5lRlHUYB2Qcxg9vuc" "LetMeIn" "SodiumChloride" 1 }
    { "6kGMuMHevkzrmc3vDb32xPrEMsQtRenPrGQcPB1ieZ4" "LetMeIn" "SodiumChloride" 2 }
    { "bahsuV9ZUkETXTGYNfWa_9GRedJhadDzT57xf_MkZSM" "LetMeIn" "SodiumChloride" 10 }
    { "JE-1ME7nifGw3K51P1ZwveG7JlevqUP6cUsZIUmaoto" "LetMeIn" "SodiumChloride" 40 }
    { "xblSvY2ubb80WpQL_6QvaGiGT-RY-Ls6jmYy8wBFi9Y" "LetMeIn" "VQjbCSbb2q1t4" 1 }
    { "HqpVKZ6SQGvIv2tv74PZA2-_oEPJJUBr5P-qiX4VkVk" "LetMeIn" "VQjbCSbb2q1t4" 2 }
    { "GV7ZEbZePKA5sjJLpkbmRIZX-a0XhQ7Ws2agaZtJmyY" "LetMeIn" "VQjbCSbb2q1t4" 10 }
    { "rFAz7o1Tj8EXriAes1wnsuBNmD552QuHE3istoFqRg0" "LetMeIn" "VQjbCSbb2q1t4" 40 }
    { "mQlWOWkB8eqlB5FUYFXdl_s550dRebMJQXuBKDHuD44" "CorrectHorseBatteryStaple" "" 1 }
    { "y8e0RPoB34-Bad1147R8quLFzDpPp4RfK7rwCTbLzIU" "CorrectHorseBatteryStaple" "" 2 }
    { "RW5nOuGw-rny_HLvokOfMJbJKBJJKWwKdcUpbvdP588" "CorrectHorseBatteryStaple" "" 10 }
    { "IUgOQReEvgBy67mDlJOech2IsH_n0TRx8lZpXLfoEg8" "CorrectHorseBatteryStaple" "" 40 }
    { "AMCx7-FyX4O7y22fvNiACZ-D290xVzSqOM5p2NJmq3A" "CorrectHorseBatteryStaple" "NaCl" 1 }
    { "jnnkXZIS1cSUPM-M0e5DfILa3TIRPB8wa6wVFgVJ0CU" "CorrectHorseBatteryStaple" "NaCl" 2 }
    { "IUtToW1pvt4oHSTcGOAOsJNt3DY1zgjMhSb2CkWeiS0" "CorrectHorseBatteryStaple" "NaCl" 10 }
    { "mdFs56rbLP9kRPBnmy-q7PQAWNMJ6S4HzhoIoJRkATA" "CorrectHorseBatteryStaple" "NaCl" 40 }
    { "13XutM1ZkmHhs0xXCBektQ8xMOEZdA_ZSvqmgi8uxLw" "CorrectHorseBatteryStaple" "SodiumChloride" 1 }
    { "sx1AQJa0pmYrzbRT5p9UZvAwj_l-GL-MIQbKILRhy1M" "CorrectHorseBatteryStaple" "SodiumChloride" 2 }
    { "zDf6nawUC4M8NquJZ4WSKBhvaxPp6p6Ig-fNe9e-xjw" "CorrectHorseBatteryStaple" "SodiumChloride" 10 }
    { "IFGmTAZdY4OzMOEh5Pty0qV2bdbC8ugKnOjnRw77p08" "CorrectHorseBatteryStaple" "SodiumChloride" 40 }
    { "ikN814WeMShiE4oNBW6aFcZGOlqTqKBTqG3iLArEc8A" "CorrectHorseBatteryStaple" "VQjbCSbb2q1t4" 1 }
    { "lcTa0X-mMVkQv5-mtLfbQfp1EC2iAxKog5rs4c0OS9g" "CorrectHorseBatteryStaple" "VQjbCSbb2q1t4" 2 }
    { "rBnxOoir4afsUnydcwi9IF-oKxQkWCWxXjHtgwAwXGw" "CorrectHorseBatteryStaple" "VQjbCSbb2q1t4" 10 }
    { "-Vy56eP1gZGJEsqZ6Sk0NS_msW9DrUB6Bl0ombFJXGs" "CorrectHorseBatteryStaple" "VQjbCSbb2q1t4" 40 }
    { "ya63iZvjc_I7hs2-shxOg8G9lOXURAwYc6FwYw_x_cM" "CYYnxbrqmpgkS7" "" 1 }
    { "uFKFferleazczVPKjpYFxZKwEaOwVK4ouo3R9ULaedk" "CYYnxbrqmpgkS7" "" 2 }
    { "URZNRcHbWh6HYwj2rYaNWbzU_P6YCoQL0rq1JcsbUPE" "CYYnxbrqmpgkS7" "" 10 }
    { "p9_zme8YNX2CLFdxp100K85XAqMlzb2QLjZqoKfLMCY" "CYYnxbrqmpgkS7" "" 40 }
    { "2iG078FmJ6Z9yT9zbeWZvv82mNrbMkTtoLu8weVC55s" "CYYnxbrqmpgkS7" "NaCl" 1 }
    { "0IPa5wV8o37Tkzo0h8UNVVigeANttWUcNL-nGrPYgV4" "CYYnxbrqmpgkS7" "NaCl" 2 }
    { "-4nSUOmT-gwHwDG7PG4jyAPcHIUpUZaz9a384qZ9Lj8" "CYYnxbrqmpgkS7" "NaCl" 10 }
    { "5fxPvTCol3sUYAzf9z9sh1vHOdGqLl19MuJVNnePcAg" "CYYnxbrqmpgkS7" "NaCl" 40 }
    { "0v4YNVo0GF0I5aZOBVrXZ0bKENeamKPjpos2lUqmQbM" "CYYnxbrqmpgkS7" "SodiumChloride" 1 }
    { "RO-vgjd8ilP5Y0cHBU93mN5lVuB9zt465uKgMgiGLQQ" "CYYnxbrqmpgkS7" "SodiumChloride" 2 }
    { "bLQ6DfJbO2XpUxdJot04RIhWOR8qgJcjFnEFDQONuFk" "CYYnxbrqmpgkS7" "SodiumChloride" 10 }
    { "XpXjJELxMeUUw1qnv05usNyDoWwt5WrL5p6WyRjJxsM" "CYYnxbrqmpgkS7" "SodiumChloride" 40 }
    { "NatV8sJb8t58TRHGDOg3HILShNsQPzwoxBsKAFeoJA8" "CYYnxbrqmpgkS7" "VQjbCSbb2q1t4" 1 }
    { "cLkYqqjLdjNEYkJldupheJ6MHXlumxjGKJcg6jnsZr0" "CYYnxbrqmpgkS7" "VQjbCSbb2q1t4" 2 }
    { "lZSL2wyrd1_fuRV6deJozFe9UNPgyzONNk4tblXRjj0" "CYYnxbrqmpgkS7" "VQjbCSbb2q1t4" 10 }
    { "spGpbAQ9YLsfGxx5e-af5jNHISO1JyjdKFL6LVztmzs" "CYYnxbrqmpgkS7" "VQjbCSbb2q1t4" 40 }
}

{ t } [
    test-vectors [ first4 enscrypt swap sodium-base64>bin = ] all?
] unit-test
