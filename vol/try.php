<?php
require_once __DIR__ . '/../vendor/autoload.php';  // Adjust path to go up one directory

use Silarhi\Hello;

$hello = new Hello();
echo $hello->display() . "\n";
?>
