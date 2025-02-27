# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    georef(table, domain)

Georeference `table` on geospatial `domain`.
"""
georef(table, domain) = meshdata(domain, etable=table)

"""
    georef(table, coords)

Georeference `table` on a `PointSet(coords)`.
"""
georef(table, coords::AbstractVecOrMat) = georef(table, PointSet(coords))

"""
    georef(table, coordnames)

Georeference `table` using columns `coordnames`.
"""
function georef(table, coordnames::NTuple)
  colnames = Tables.columnnames(table)
  @assert coordnames ⊆ colnames "invalid coordinates for table"
  @assert !(colnames ⊆ coordnames) "table must have at least one variable"
  vars   = setdiff(colnames, coordnames)
  vtable = TableOperations.select(table, vars...)
  ctable = TableOperations.select(table, coordnames...)
  coords = Tuple.(Tables.rowtable(ctable))
  georef(vtable, coords)
end

"""
    georef(tuple, domain)

Georeference named `tuple` on geospatial `domain`.
"""
function georef(tuple::NamedTuple, domain)
  flat = (; (var=>vec(val) for (var,val) in pairs(tuple))...)
  georef(TypedTables.Table(flat), domain)
end

# fix ambiguity between other methods
georef(tuple::NamedTuple, coordnames::NTuple) =
  georef(TypedTables.Table(tuple), coordnames)

"""
    georef(tuple, coords)

Georefrence named `tuple` on `PointSet(coords)`.
"""
georef(tuple::NamedTuple, coords::AbstractVecOrMat) = georef(tuple, PointSet(coords))

"""
    georef(tuple; origin=(0.,0.,...), spacing=(1.,1.,...))

Georeference named `tuple` on `CartesianGrid(size(tuple[1]), origin, spacing)`.
"""
georef(tuple;
       origin=ntuple(i->0., ndims(tuple[1])),
       spacing=ntuple(i->1., ndims(tuple[1]))) = georef(tuple, origin, spacing)

georef(tuple, origin, spacing) =
  georef(tuple, CartesianGrid(size(tuple[1]), origin, spacing))
