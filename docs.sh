appledoc --ignore "Project" --project-name "YYHRequest" --project-company "Angelo Di Paolo" --company-id com.yayuhh --output ./docs .
echo Checkout Github Pages Branch
git checkout gh-pages
cp -r /Users/angelo/Library/Developer/Shared/Documentation/DocSets/com.yayuhh.YYHRequest.docset/Contents/Resources/Documents/* ./
echo Commit Github Pages Changes
git commit -a -m "update docs"
git push origin gh-pages
git checkout master
