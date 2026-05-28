<?php
$xml = file_get_contents('https://www.cnnindonesia.com/ekonomi/rss');
$rss = simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA);
var_dump($rss->channel->item[0]);
