echo ">>> Installing Julia v0.7"
wget --quiet https://status.julialang.org/download/linux-x86_64 -O /tmp/julia-0.7.tar.gz
mkdir -p /opt/julia-0.7/
tar -xzf /tmp/julia-0.7.tar.gz --strip-components 1 -C /opt/julia-0.7/
rm /tmp/julia-0.7.tar.gz
ln -sf /opt/julia-0.7/bin/julia /usr/bin/j7

# Add relevant Julia v0.7 packages
echo ">>> Installing Julia v0.7 packages"
j7 -e "Pkg.init()"
cp $APPS/julia/REQUIRE /opt/julia-pkgs/v0.7/
j7 -e "Pkg.resolve()"
j7 $APPS/julia/prepare_packages.jl
