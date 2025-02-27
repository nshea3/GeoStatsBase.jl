@testset "Plotting" begin
  Random.seed!(123)
  z₁ = randn(10000)
  z₂ = z₁ + randn(10000)
  d = georef((z₁=z₁,z₂=z₂), CartesianGrid(100,100))

  agri = georef(CSV.File(joinpath(datadir,"agriculture.csv")), (:x,:y))

  if visualtests
    @test_reference "data/agriculture.png" plot(agri, (:band4,:crop), ms=0.2)
  end

  @testset "HScatter" begin
    if visualtests
      sdata = georef(CSV.File(joinpath(datadir,"samples2D.tsv")), (:x,:y))
      p0 = hscatter(sdata, :value, lag=0)
      p1 = hscatter(sdata, :value, lag=1)
      p2 = hscatter(sdata, :value, lag=2)
      p3 = hscatter(sdata, :value, lag=3)
      plt = plot(p0, p1, p2, p3, layout=(2,2), size=(600,600))
      @test_reference "data/hscatter.png" plt
    end
  end
end
