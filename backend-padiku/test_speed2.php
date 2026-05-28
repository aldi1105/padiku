<?php
$start = microtime(true);
$xml = @file_get_contents('https://www.cnnindonesia.com/ekonomi/rss');
if ($xml) {
    $rss = simplexml_load_string($xml);
    echo "RSS took: " . (microtime(true) - $start) . " seconds\n";
    $count = count($rss->channel->item);
    echo "Items: $count\n";
} else {
    echo "Failed to fetch RSS\n";
}
