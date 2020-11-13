# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    split(object, fraction, [normal])

Split spatial `object` into two parts where the first
part has a `fraction` of the elements. Optionally, the
split is performed perpendicular to a `normal` direction.
"""
function split(object, fraction::Real, normal=nothing)
  if isnothing(normal)
    partition(object, FractionPartitioner(fraction))
  else
    partition(object, BisectFractionPartitioner(normal, fraction))
  end
end