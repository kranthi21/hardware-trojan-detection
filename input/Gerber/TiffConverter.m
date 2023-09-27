files = dir('*.png');
n = length(files);

for i = 1:n
    FileName = files(i).name;
    img = imread(FileName);
    [~, FileName, ext]= (fileparts(FileName));
    outFile = strcat(FileName,'.tif');
    imwrite(img, outFile)
end