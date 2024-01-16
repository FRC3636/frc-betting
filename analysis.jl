using DataFrames, DataFramesMeta, SQLite, Gadfly

n_top = 16

df = DataFrame(DBInterface.execute(
    SQLite.DB("rankings.db"),
    """
    SELECT * FROM rankings
        WHERE year >= 2014
        AND year != 2020
        AND year != 2021;
    """
))

# Team Shares of District Points by Rank and Year
@chain df begin
    @subset(_, :district .== "pnw")
    groupby(_, [:year, :district])
    @transform(_, :share = :points ./ sum(:points))
    @subset(_, :rank .<= n_top)
    plot(
        _,
        x=:rank,
        y=:share,
        color=:year,
        linestyle=:district,
        Geom.line,
        Scale.color_discrete(),
        Guide.title("Share of District Points by Rank"),
    )
end

# Team Share of World-Qualifying District Points by Rank and Year
@chain df begin
    @subset(_, :district .== "pnw")
    @subset(_, :rank .<= n_top)
    groupby(_, [:year, :district])
    @transform(_, :share = :points ./ sum(:points))
    plot(
        _,
        x=:rank,
        y=:share,
        color=:year,
        linestyle=:district,
        Geom.line,
        Scale.color_discrete(),
        Guide.title("Team Share of World-Qualifying District Points by Rank"),
    )
end

# Worlds-Qualifying Share of District Points by Year
@chain df begin
    groupby(_, [:year, :district])
    @combine(_, :share = sum(:points .* (:rank .<= n_top)) / sum(:points))
    plot(
        _,
        x=:year,
        y=:share,
        color=:district,
        Geom.point,
        Geom.line,
        Guide.title("Worlds-Qualifying Share of District Points"),
    )
end
