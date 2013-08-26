mkdir -p work
mkdir -p release
rm -rf work/*
rm -rf release/*
mv sketches/Infiltrators/application.* work/
cd work
for target in application.*; do tar czf ../release/$target.tgz $target; done

