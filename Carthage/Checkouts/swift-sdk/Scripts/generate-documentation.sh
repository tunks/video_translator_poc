#!/bin/bash

# Set the output directory
outdir=${1:-gh-pages}

################################################################################
# Define list of services
################################################################################

services=(
  AssistantV1
  ConversationV1
  DiscoveryV1
  LanguageTranslatorV3
  NaturalLanguageClassifierV1
  NaturalLanguageUnderstandingV1
  PersonalityInsightsV3
  SpeechToTextV1
  TextToSpeechV1
  ToneAnalyzerV3
  VisualRecognitionV3
)

################################################################################
# Change directory to repository root
################################################################################

pushd `dirname $0` > /dev/null
root=`pwd`
popd > /dev/null
cd $root
cd ..

################################################################################
# Create folder for generated documentation
################################################################################

if [ -d "${outdir}" ]; then
  echo "The output directory ${outdir} already exists."
  echo "Please remove the directory and try again."
  exit
fi

mkdir ${outdir}
mkdir ${outdir}/services

################################################################################
# Run Jazzy to generate documentation
################################################################################

for service in ${services[@]}; do
  mkdir ${outdir}/services/${service}
  xcodebuild_arguments=-project,WatsonDeveloperCloud.xcodeproj,-scheme,${service}
  jazzy \
    --xcodebuild-arguments $xcodebuild_arguments \
    --output ${outdir}/services/${service} \
    --clean \
    --github_url https://github.com/watson-developer-cloud/ios-sdk \
    --hide-documentation-coverage
done

################################################################################
# Generate index.html and copy supporting files
################################################################################

cp Scripts/generate-documentation-resources/index-prefix ${outdir}/index.html
for service in ${services[@]}; do
  html="<li><a target="_blank" href="./services/${service}/index.html">${service}</a></li>"
  echo ${html} >> ${outdir}/index.html
done
cat Scripts/generate-documentation-resources/index-postfix >> ${outdir}/index.html

cp -r Scripts/generate-documentation-resources/* ${outdir}
rm ${outdir}/index-prefix ${outdir}/index-postfix

################################################################################
# Collect undocumented.json files
################################################################################

touch ${outdir}/undocumented.json
echo "[" >> ${outdir}/undocumented.json

declare -a undocumenteds
undocumenteds=($(ls -r ${outdir}/services/*/undocumented.json))

if [ ${#undocumenteds[@]} -gt 0 ]; then
  echo -e -n "\t" >> ${outdir}/undocumented.json
  cat "${undocumenteds[0]}" >> ${outdir}/undocumented.json
  unset undocumenteds[0]
  for f in "${undocumenteds[@]}"; do
    echo "," >> ${outdir}/undocumented.json
    echo -e -n "\t" >> ${outdir}/undocumented.json
    cat "$f" >> ${outdir}/undocumented.json
  done
fi

echo "" >> ${outdir}/undocumented.json
echo "]" >> ${outdir}/undocumented.json
