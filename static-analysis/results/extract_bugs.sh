#!/bin/bash

LOG="scan-build.log"
OUT="static-analysis-markup.md"
SRC_ROOT="../libxml2"

echo "# Static Analysis Findings Review" > $OUT
echo "" >> $OUT

count=1

grep "warning:" $LOG | awk -F: '!seen[$NF]++' | head -n 3 | \
while IFS=: read file line col rest
do

rule=$(echo $rest | sed 's/.*warning: //')

severity="Medium"

if echo "$rule" | grep -qi "null"; then severity="High"; fi
if echo "$rule" | grep -qi "leak"; then severity="High"; fi
if echo "$rule" | grep -qi "use-after"; then severity="Critical"; fi

echo "## Finding $count" >> $OUT
echo "" >> $OUT

echo "**Rule ID:** $rule" >> $OUT
echo "**Severity:** $severity" >> $OUT
echo "" >> $OUT

echo "**Location:**" >> $OUT
echo "File: $file  " >> $OUT
echo "Line: $line  " >> $OUT
echo "" >> $OUT

echo "**Code fragment:**" >> $OUT
echo "\`\`\`c" >> $OUT

sed -n "$((line-3)),$((line+3))p" $SRC_ROOT/$file >> $OUT

echo "\`\`\`" >> $OUT
echo "" >> $OUT

echo "**Validity:** (подтверждается / не подтверждается / недостаточно информации)" >> $OUT
echo "" >> $OUT

echo "**Code description:**" >> $OUT
echo "(описать что делает код)" >> $OUT
echo "" >> $OUT

echo "**Risk / Impact:**" >> $OUT
echo "(описать потенциальный риск)" >> $OUT
echo "" >> $OUT

echo "**Recommendation:**" >> $OUT
echo "(как исправить или снизить риск)" >> $OUT
echo "" >> $OUT
echo "---" >> $OUT
echo "" >> $OUT

count=$((count+1))

done

echo "Report generated: $OUT"
