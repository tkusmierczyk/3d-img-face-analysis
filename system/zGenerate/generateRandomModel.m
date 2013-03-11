function pts = generateRandomModel(noOfPts, space)

x = rand(noOfPts, 1)*space;
y = rand(noOfPts, 1)*space;
z = rand(noOfPts, 1)*space;

pts = [x y z];