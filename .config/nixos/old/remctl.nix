
with import <nixpkgs> {};
stdenv.mkDerivation {
    src = fetchurl {
        url = "https://archives.eyrie.org/software/kerberos/remctl-3.18.tar.gz";
        #rev = "release/3.18";
        #rev = "release/${version}";
        #sha256 = "0h1kpccpq0y8aw151p2h0k7kd7dgfbs03hdhbqf3qd9hbf2cvb70";
        sha256 = "0hkx6m7v09wddi2ianwc87kbb19pwacq4gf3zdsmwn6rddmqjg1r";
    };
    name = "remctl";
    buildInputs = [ gss krb5 libevent ]; # autoconf automake
}
