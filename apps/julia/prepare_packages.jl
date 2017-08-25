Pkg.update()

const pkgs = collect(keys(Pkg.installed()))
const pkgs_failed_build = String[]
const pkgs_failed_using = String[]

for p in pkgs
    try
        Pkg.build(p)
        println("BUILT: $p")
    catch
        push!(pkgs_failed_build, p)
        println("ERROR BUILDING: $p")
    end
end

for p in pkgs
    try
        @eval using $(Symbol(p))
        println("USING: $p")
    catch
        push!(pkgs_failed_using, p)
        println("ERROR USING: $p")
    end
end

isempty(pkgs_failed_build) && isempty(pkgs_failed_using) && return 0

open("errors.txt", "w") do file
    redirect_stdout(file) do
        println("Failed to build:")
        println()
        println.(pkgs_failed_build)

        println()

        println("Failed to use:")
        println()
        println.(pkgs_failed_using)
    end
end
