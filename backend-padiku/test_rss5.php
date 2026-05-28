<?php
$keywords = ['padi', 'beras', 'gabah', 'sawah', 'petani padi', 'panen padi', 'pupuk', 'bulog', 'penggilingan'];
$sources = [
    'https://www.cnnindonesia.com/ekonomi/rss',
    'https://www.antaranews.com/rss/ekonomi.xml',
    'https://www.cnbcindonesia.com/news/rss',
    'https://ekbis.sindonews.com/rss',
    'https://www.republika.co.id/rss/ekonomi',
    'https://www.suara.com/rss/bisnis',
    'https://rss.tempo.co/bisnis'
];

$items = [];
foreach($sources as $source) {
    $xml = @file_get_contents($source);
    if ($xml) {
        $rss = @simplexml_load_string($xml);
        if ($rss && $rss->channel && $rss->channel->item) {
            foreach($rss->channel->item as $item) {
                $title = strtolower((string) $item->title);
                $desc = strtolower((string) $item->description);
                $timestamp = strtotime((string) $item->pubDate);
                
                // Batasi hanya berita dari hari ini sampai 4 hari yang lalu
                if (time() - $timestamp > 4 * 86400) {
                    continue;
                }

                $isMatch = false;
                foreach($keywords as $kw) {
                    if (strpos($title, $kw) !== false || strpos($desc, $kw) !== false) {
                        $isMatch = true;
                        break;
                    }
                }
                if ($isMatch) {
                    $items[] = (string) $item->title . " (" . parse_url($source, PHP_URL_HOST) . ")";
                }
            }
        }
    }
}
echo "Found " . count($items) . " items.\n";
foreach($items as $i) {
    echo "- " . $i . "\n";
}
