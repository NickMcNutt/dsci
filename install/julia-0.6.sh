echo ">>> Installing Julia v0.6"
wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6-latest-linux-x86_64.tar.gz -O /tmp/julia-0.6.tar.gz
mkdir -p /opt/julia-0.6/
tar -xzf /tmp/julia-0.6.tar.gz --strip-components 1 -C /opt/julia-0.6/
rm /tmp/julia-0.6.tar.gz
ln -sf /opt/julia-0.6/bin/julia /usr/bin/j6
ln -sf /opt/julia-0.6/bin/julia /usr/bin/julia

echo ">>> Installing Julia v0.6 packages"
j6 -e "Pkg.init()"
cp $APPS/julia/REQUIRE /opt/julia-pkgs/v0.6/
j6 -e "Pkg.resolve()"
j6 $APPS/julia/prepare_packages.jl
