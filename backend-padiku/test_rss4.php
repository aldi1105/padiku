<?php
$keywords = ['padi', 'beras', 'gabah', 'sawah', 'petani padi', 'panen padi', 'pupuk', 'bulog', 'penggilingan'];
$sources = [
    'https://www.cnnindonesia.com/ekonomi/rss',
    'https://www.antaranews.com/rss/ekonomi.xml',
    'https://www.cnbcindonesia.com/news/rss'
];
foreach($sources as $source) {
    $xml = @file_get_contents($source);
    if ($xml) {
        $rss = @simplexml_load_string($xml);
        if ($rss && $rss->channel && $rss->channel->item) {
            foreach($rss->channel->item as $item) {
                $title = strtolower((string) $item->title);
                $desc = strtolower((string) $item->description);
                $isMatch = false;
                foreach($keywords as $kw) {
                    if (strpos($title, $kw) !== false || strpos($desc, $kw) !== false) {
                        $isMatch = true;
                        break;
                    }
                }
                if ($isMatch) {
                    echo (string)$item->title . " - " . (string)$item->pubDate . "\n";
                }
            }
        }
    }
}
