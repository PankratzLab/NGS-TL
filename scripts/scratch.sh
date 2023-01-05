







module load parallel
module load samtools/1.14

# find /scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/ -type f -name "*LTL.k.*.gz" |parallel "rm {}"
outDir=/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/
mkdir -p $outDir

# rsync -avzP /Volumes/Beta2/NGS/topmed/biocat/manifest* msi:/scratch.global/lanej/topMed/LTL/experimental//

function query() {
    
    regionsSearch=/home/tsaim/lane0212/git/Analysis/LTL/estimate/experiment/ltl.target.bed
    ref=/home/pankrat2/public/bin/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
    samtools=/home/tsaim/lane0212/anaconda3/bin/samtools
    
    outFile=$(echo "$4"| sed s/.cram/.LTL.bam/g)
    echo $outFile
    
    if [ ! -f "$outFile".bai ]
    
    then
        
        
        cramLink="https://ga4gh-api.sb.biodatacatalyst.nhlbi.nih.gov/ga4gh/drs/v1/objects/$1/access/aws-us-east-1"
        cramFile=$(curl -H "X-SBG-Auth-Token: $3" "$cramLink"|python3 -c "import sys, json; print(json.load(sys.stdin)['url'])" )
        
        
        craiLink="https://ga4gh-api.sb.biodatacatalyst.nhlbi.nih.gov/ga4gh/drs/v1/objects/$2/access/aws-us-east-1"
        craiFile=$(curl -H "X-SBG-Auth-Token: $3" "$craiLink"|python3 -c "import sys, json; print(json.load(sys.stdin)['url'])" )
        
        echo "cram $cramFile"
        echo "crai $craiFile"
        
        # If we do not add the perl portion, -X to specify the crai gets angry
        samtools view -b -o "$outFile" -X --reference $ref -M -L "$regionsSearch" -h "$cramFile" "$craiFile" $(perl -ane '{print "$F[0]:$F[1]-$F[2] "}' $regionsSearch )
        # samtools view -b -o "$outFile" -X --reference $ref -M -L "$regionsSearch" -h "$cramFile" "$craiFile" $(perl -ane '{print "$F[0]:$F[1]-$F[2] "}' $regionsSearch )
        
        # | awk -v OFS='\t'  -v readIndex=10 -v k=12  '{if(gsub(/CCCTAA/, "CCCTAA",$readIndex) >= k || gsub(/TTAGGG/, "TTAGGG",$readIndex) >=k || /@/){print $0}}'\
        
        # samtools  view  -X -b --verbosity 10 --reference $ref "$cramFile" "$craiFile" $region > "$outFile"
        samtools index "$outFile"
        samtools stats "$outFile" |gzip > "$outFile".stats.txt.gz
    else
        echo "skipping download of existing $outFile "
    fi
    
    
    
    ks=($(seq 1 1 20))
    for k in "${ks[@]}"; do
        echo "hi $k"
        
        outFileFilter=$(echo "$4"| sed s/.cram/.LTL/g)
        outFileFilter="$outFileFilter".k.$k.stats.txt.gz
        if [ ! -f "$outFileFilter" ]
        
        then
            echo "$outFileFilter"
            samtools view -h $outFile \
            | awk -v OFS='\t'  -v readIndex=10 -v k=$k  '{if(gsub(/CCCTAA/, "CCCTAA",$readIndex) >= k || gsub(/TTAGGG/, "TTAGGG",$readIndex) >=k || /@/){print $0}}' \
            | samtools stats |gzip > "$outFileFilter"
            
            
            
        else
            echo "skipping parsing of "$outFileFilter" "
        fi
    done
}

export -f query

parseManifests=("/scratch.global/lanej/topMed/LTL/experimental/manifest_20220711_143025.parse.tsv" "/scratch.global/lanej/topMed/LTL/experimental/manifest_20220816_160349.parse.tsv")


for parseManifest in "${parseManifests[@]}"; do
    echo "$parseManifest"
    grep -v "indexId" "$parseManifest" \
    |parallel -j24 --colsep '\t' "query {2} {3} $SB_TOKEN $outDir/{1}"
    
done

outRawCounts=/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/rawCounts.txt


function count() {
    local bam=$1
    local out=$2
    local counts=$(samtools view -c $bam)
    
    printf "%s\t%s\n" "$out" "$counts"
    
}


export -f count


find $outDir -type f -name "*.bam" \
|parallel -j24 "count {} {/.}" > $outRawCounts


# 200 samples, ~ 15 minutes (compute time not important), and 1.6G download


#  cramFile="https://nih-nhlbi-datacommons.s3.amazonaws.com/NWD100227.b38.irc.v1.cram?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAYXPGNV6OLTUXKWGE%2F20221209%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221209T184057Z&X-Amz-Expires=3600&X-Amz-Security-Token=FwoGZXIvYXdzEEwaDCif5xvPXITtlGSsgyLNAeqwEx2BstX9rRSImGm7KHp0jHwM84%2Bd4w7g25GPonJjFU5j0XxKPJmU7Prcd6ZnWEQAV3tXprr1xyhPTBoo2Zy5I9KToKSgnfNseN7p9FWIZOoBfwBJt%2FOOmaBlGxr8g61cNgwgQz0VLJoac0fIF57YVnlPNNO%2Fm4e9oSashbmaPSU4%2FxYzxtDPd9ykd%2FwDaCmgIf1C%2BuEYmragKsUv3qjBfiWpNTPn4wIRzdI9qvhfoCWnxPtewW08Buw2QIvI14h2fJFy0NKvbMFlmOoouYLOnAYyLeYQ5Tf7OmxyVaWyhrsX9RlQqvQpLlNPcM5wVkx13R9rUrl5u0%2FobFRlcHMnCw%3D%3D&X-Amz-SignedHeaders=host&client_id=sVjOHeJQKCHK7EmjnYQLrqAfAGLgzCSk6tf0hkCy&user_id=611&username=J.LANE&X-Amz-Signature=5207e41f6e6c1b2a95b76f8b480a80e9cacfc5bff8098bd82254685dd302c315"
#  craiFile=" https://nih-nhlbi-datacommons.s3.amazonaws.com/NWD100227.b38.irc.v1.cram.crai?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAYXPGNV6OKSRZOPZA%2F20221209%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221209T184059Z&X-Amz-Expires=3600&X-Amz-Security-Token=FwoGZXIvYXdzEEwaDPmV699W66kXJx3RgiLNAWFoLpD%2FH2E4ceNWYqvtC%2FHD7oOMcbztN7M6AVd%2B%2FRTuLhdDUdMKxZqepuQkNkIb%2B%2BttrNN6BTIGaVXOFl6ZImMFZY7VClxQf0aZWzdtGraISKVEhyUeUSesrB8RjT4ZwBeHo7ujPIlggmEi7CviLuzYqaKTiUoomjXnPMv80yHg8B%2F8d3rYyyGfdHpLgU1j39NPyHCxIS6EAc7qsi67%2BO2yOUZ5rmLMGSnxe0sfugkG5ZR7SEn6XgDJZNRNWYGUlc0GBmIUUxwx1c%2F0fFkou4LOnAYyLSHcgICio0cBXv%2BDAU1U%2BEz%2FHR49RK2l%2FCjmOjH9lG5w08MzcqyROwoJO%2F5I%2Fw%3D%3D&X-Amz-SignedHeaders=host&client_id=sVjOHeJQKCHK7EmjnYQLrqAfAGLgzCSk6tf0hkCy&user_id=611&username=J.LANE&X-Amz-Signature=3693deb6289e4a46052a18c05de6d3e5bcc12ef70c923bcdefcfe71b2f69522e"
# samtools view -b -X --reference $ref -M -L "$regionsSearch" -h "$cramFile" "$craiFile" $(perl -ane '{print "$F[0]:$F[1]-$F[2] "}' $regionsSearch ) |samtools view

# $ 4.70 is starting cost Dec2.

# rsync -avzP /Volumes/Beta2/NGS/topmed/biocat/manifest* msi:/scratch.global/lanej/topMed/LTL/experimental//

# tar --exclude='*.bam*' -czvf bams_BDC_LTL_V2.stats.tar.gz /scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2
# rsync -avzP "msi:/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2.stats.tar.gz" /Volumes/Beta2/NGS/topmed/MICA/anvil_terra/bams_BDC_LTL_V2/

# rsync -avzP "msi:/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/*k.9.stats.txt.gz" /Volumes/Beta2/NGS/topmed/MICA/anvil_terra/bams_BDC_LTL_V2/

# rsync -avzP msi:/scratch.global/lanej/topMed/LTL/experimental/bams_BDC_LTL_V2/rawCounts.txt /Volumes/Beta2/NGS/topmed/MICA/anvil_terra/bams_BDC_LTL_V2/

