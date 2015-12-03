<?php
echo phpversion();
echo '<br />';

if (isset($_GET['q']) && $_GET['q'] == 'toto') {
    echo 'Url rewriting works !';
} else {
  echo 'Url rewriting do not work :(';
}
