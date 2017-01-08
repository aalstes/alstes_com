# Originally from https://www.contentful.com/developers/docs/ruby/tutorials/automated-rebuild-and-deploy-with-circleci-and-webhooks/

# Copy static site
CWD=`pwd`

# Clone Pages repository
cd /tmp
git clone https://github.com/aalstes/aalstes.github.io.git build
# cd build && git checkout -b YOUR_BRANCH origin/YOUR_BRANCH # If not using master

# Trigger Jekyll rebuild
cd $CWD
# Env variables work fine here, but not within _config.yml, for some reason.
# So we substitute the variables in _config.yml here, using sed.
sed -i "s/ENV_CONTENTFUL_SPACE_ID/$ENV_CONTENTFUL_SPACE_ID/" _config.yml
sed -i "s/ENV_CONTENTFUL_ACCESS_TOKEN/$ENV_CONTENTFUL_ACCESS_TOKEN/" _config.yml
echo "After editing:"
cat _config.yml
bundle exec jekyll contentful
bundle exec jekyll build

# Push newly built repository
cp -r $CWD/_site/* /tmp/build

cd /tmp/build

git config --global user.email "aalstes@gmail.com"
git config --global user.name "Anton Alstes"

git add .
git commit -m "Automated Rebuild"
git push -f origin master
