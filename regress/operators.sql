--- operator testing (testing is on the BOUNDING BOX (2d), not the actual geometries)

-- overlap or left of

select '77','POINT(1 1)'::GEOMETRY &< 'POINT(1 1)'::GEOMETRY as bool;
select '78','POINT(1 1)'::GEOMETRY &< 'POINT(2 1)'::GEOMETRY as bool;
select '79','POINT(2 1)'::GEOMETRY &< 'POINT(1 1)'::GEOMETRY as bool;

-- strictly left

select '80','POINT(1 1)'::GEOMETRY << 'POINT(1 1)'::GEOMETRY as bool;
select '81','POINT(1 1)'::GEOMETRY << 'POINT(2 1)'::GEOMETRY as bool;
select '82','POINT(2 1)'::GEOMETRY << 'POINT(1 1)'::GEOMETRY as bool;

-- overlap or right

select '83','POINT(1 1)'::GEOMETRY &> 'POINT(1 1)'::GEOMETRY as bool;
select '84','POINT(1 1)'::GEOMETRY &> 'POINT(2 1)'::GEOMETRY as bool;
select '85','POINT(2 1)'::GEOMETRY &> 'POINT(1 1)'::GEOMETRY as bool;

-- strictly right

select '86','POINT(1 1)'::GEOMETRY >> 'POINT(1 1)'::GEOMETRY as bool;
select '87','POINT(1 1)'::GEOMETRY >> 'POINT(2 1)'::GEOMETRY as bool;
select '88','POINT(2 1)'::GEOMETRY >> 'POINT(1 1)'::GEOMETRY as bool;

-- overlap

select '89','POINT(1 1)'::GEOMETRY && 'POINT(1 1)'::GEOMETRY as bool;
select '90','POINT(1 1)'::GEOMETRY && 'POINT(2 2)'::GEOMETRY as bool;
select '91','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(1 1, 2 2)'::GEOMETRY as bool;
select '92','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(1.0001 1, 2 2)'::GEOMETRY as bool;
select '93','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(1 1.0001, 2 2)'::GEOMETRY as bool;
select '94','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(1 0, 2 2)'::GEOMETRY as bool;
select '95','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(1.0001 0, 2 2)'::GEOMETRY as bool;

select '96','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(0 1, 1 2)'::GEOMETRY as bool;
select '97','MULTIPOINT(0 0, 1 1)'::GEOMETRY && 'MULTIPOINT(0 1.0001, 1 2)'::GEOMETRY as bool;

--- contains 

select '98','MULTIPOINT(0 0, 10 10)'::GEOMETRY ~ 'MULTIPOINT(5 5, 7 7)'::GEOMETRY as bool;
select '99','MULTIPOINT(5 5, 7 7)'::GEOMETRY ~ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;
select '100','MULTIPOINT(0 0, 7 7)'::GEOMETRY ~ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;
select '101','MULTIPOINT(-0.0001 0, 7 7)'::GEOMETRY ~ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;

--- contained by 

select '102','MULTIPOINT(0 0, 10 10)'::GEOMETRY @ 'MULTIPOINT(5 5, 7 7)'::GEOMETRY as bool;
select '103','MULTIPOINT(5 5, 7 7)'::GEOMETRY @ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;
select '104','MULTIPOINT(0 0, 7 7)'::GEOMETRY @ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;
select '105','MULTIPOINT(-0.0001 0, 7 7)'::GEOMETRY @ 'MULTIPOINT(0 0, 10 10)'::GEOMETRY as bool;

-- overlap or below  &<|

select 'ovbl1',ST_MakeEnvelope(2,2,4,4) &<| ST_MakeEnvelope(2,2,4,4); --t
select 'ovbl2',ST_MakeEnvelope(2,1,4,4) &<| ST_MakeEnvelope(2,2,4,4); --t
select 'ovbl3',ST_MakeEnvelope(2,1,4,5) &<| ST_MakeEnvelope(2,2,4,4); --f
select 'ovbl4',ST_MakeEnvelope(2,0,4,1) &<| ST_MakeEnvelope(2,2,4,4); --t

-- strictly below    <<|

select 'bl1',ST_MakeEnvelope(2,1,4,4) <<| ST_MakeEnvelope(2,2,4,4); --f
select 'bl2',ST_MakeEnvelope(2,1,4,2) <<| ST_MakeEnvelope(2,2,4,4); --f
select 'bl2',ST_MakeEnvelope(2,0,4,1) <<| ST_MakeEnvelope(2,2,4,4); --t

-- overlap or above  |&>

select 'ovab1',ST_MakeEnvelope(2,2,4,4) |&> ST_MakeEnvelope(2,2,4,4); --t
select 'ovab2',ST_MakeEnvelope(2,2,4,5) |&> ST_MakeEnvelope(2,2,4,4); --t
select 'ovab3',ST_MakeEnvelope(2,1,4,5) |&> ST_MakeEnvelope(2,2,4,4); --f
select 'ovab4',ST_MakeEnvelope(2,5,4,8) |&> ST_MakeEnvelope(2,2,4,4); --t

-- strictly above    |>>

select 'ab1',ST_MakeEnvelope(2,2,4,8) |>> ST_MakeEnvelope(2,2,4,4); --f
select 'ab2',ST_MakeEnvelope(2,4,4,8) |>> ST_MakeEnvelope(2,2,4,4); --f
select 'ab3',ST_MakeEnvelope(2,5,4,8) |>> ST_MakeEnvelope(2,2,4,4); --t

-- same as           =

select 'eq1',ST_MakeEnvelope(2,2,4,4) = ST_MakeEnvelope(2,2,4,4); -- f
select 'eq2',ST_MakeEnvelope(2,4,4,8) = 'LINESTRING(2 4,4 8)'::geometry; -- t
select 'eq3',ST_MakePoint(0,0) = ST_MakePoint(1,0); -- f

-- box centroid distance  <->

select 'cd1', 'LINESTRING(0 0,0 10,10 10)'::geometry <->
              'LINESTRING(6 2,6 8)'::geometry; -- 1
select 'cd2', 'LINESTRING(0 0,0 10,10 10)'::geometry <->
              'LINESTRING(11 0,19 10)'::geometry; -- 10

-- box distance           <#>

select 'bd1', 'LINESTRING(0 0,0 10,10 10)'::geometry <#>
              'LINESTRING(6 2,6 8)'::geometry; -- 0
select 'bd2', 'LINESTRING(0 0,0 10,10 10)'::geometry <#>
              'LINESTRING(11 0,19 10)'::geometry; -- 1

-- nd overlap             &&&

select 'ndov1', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(3 3 3 5)'::geometry; -- f
select 'ndov2', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(3 3 5 3)'::geometry; -- f
select 'ndov3', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(3 5 3 3)'::geometry; -- f
select 'ndov4', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(5 3 3 3)'::geometry; -- f
select 'ndov5', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(3 3 3 3)'::geometry; -- t
select 'ndov6', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(2 4 2 4)'::geometry; -- t
select 'ndov7', 'LINESTRING(2 2 2 2, 4 4 4 4)'::geometry &&&
                'POINT(4 2 4 2)'::geometry; -- t
-- TODO: mixed-dimension &&& overlap