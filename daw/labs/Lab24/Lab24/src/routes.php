<?php

use Slim\Http\Request;
use Slim\Http\Response;

// Routes

$app->get('/[{num}]', function (Request $request, Response $response, array $args) {
    // Sample log message
    $this->logger->info("Slim-Skeleton '/' route");

    // Render index view
    return $this->renderer->render($response, 'num.phtml', $args);
});

$app->get('/count/[{str}]', function (Request $request, Response $response, array $args) {
    // Sample log message
    $this->logger->info("Slim-Skeleton '/' route");

    // Render index view
    return $this->renderer->render($response, 'count.phtml', $args);
});
