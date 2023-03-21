<?php

error_reporting(0);
mysqli_report(MYSQLI_REPORT_OFF);

$mysqli = new mysqli(get_config('DB_HOST'), 
                    get_config('DB_USER'), 
                    get_config('DB_PASSWORD'), 
                    get_config('DB_NAME'), 
                    get_config('DB_PORT'));

if ($mysqli->connect_errno) {
    set_flash('error', '<h1 style="color: red;">CONFIG</h1>Could not connect to database : ' . $mysqli->connect_error);
    error_log("\n\n" . $mysqli->connect_error . "\n\n");
}

function sql($query, $params = []) {
    if (get_config('DEBUG')) {
        error_log("\n\n" . $query . "\n\n" . json_encode($params) . "\n\n");
    }
    global $mysqli;

    $statement = $mysqli->prepare($query);

    if ($statement) {
        if (count($params) > 0) {
            $types = array_reduce($params, function($accumulator, $param) {
                return $accumulator . key($param);
            }, "");
    
            $values = array_map(function($param) {
                return current($param);
            }, $params);
     
            $statement->bind_param($types, ...$values);
        }

        $statement->execute();
        $result = $statement->get_result();
    
        if ($mysqli->errno) {
            if (get_config('DEBUG')) {
                set_flash('error', '<h1 style="color: red;">SQL</h1>Query error : ' . $mysqli->error);
                error_log("\n\n" . $mysqli->error . "\n");
            }
    
            return ['success' => false, 'result' => $mysqli->error];
        } 
    
        return ['success' => true, 'result' => $result];
    } else {
        if (get_config('DEBUG')) {
            set_flash('error', '<h1 style="color: red;">SQL</h1>Query error : ' . $mysqli->error);
            error_log("\n\n" . $mysqli->error . "\n");
        }

        return ['success' => false, 'result' => $mysqli->error];
    }
}

function sql_statement($query, $params = []) {
    $response = sql($query, $params);

    if ($response['success'] && is_object($response['result']) && get_config('DEBUG')) {
        $message = 'Do not call sql_statement for SQL queries that return rows';
        set_flash('error', '<h1 style="color: red;">PHP</h1>' . $message);
        error_log("\n\n" . $message . "\n");

        $response['result'] = NULL;
    } 

    if (is_bool($response['result'])) {
        $response['result'] = NULL;
    }

    return $response;
}

function sql_select($query, $params = []) {
    $response = sql($query, $params);

    if ($response['success'] && ! is_object($response['result']) && get_config('DEBUG')) {
        $message = 'Do not call sql_select for SQL queries that do NOT return rows';
        set_flash('error', '<h1 style="color: red;">PHP</h1>' . $message);
        error_log("\n\n" . $message . "\n");

        $response['result'] = NULL;
    }else if ($response['success'] && is_object($response['result'])) {
        $rows = [];

        while($row = $response['result']->fetch_assoc()) {
            array_push($rows, $row);    
            // Need to build the array manually to fetch rows 
            // when using RETURNING with DELETE clause
        }

        $response['result'] = $rows;
    }

    return $response;
}

function load_file($filename, $params = []) {
    $path = "database/$filename.sql";
    $sql = file($path);
    $sql = join(preg_grep("/(SET @|^\s*--)/", $sql, PREG_GREP_INVERT));
    preg_match_all('/@.+\b/U', $sql, $vars);

    $built_params = array_map(function($var) use ($params) {
       return $params[substr($var, 1)];
    }, $vars[0]);

    $sql = preg_replace('/@.+\b/U', '?', $sql);
    
    return compact('sql', 'built_params');
}

function load_statement($filename, $params = []) {
    $query = load_file($filename, $params);

    return sql_statement($query['sql'], $query['built_params']);
}

function load_select($filename, $params = []) {
    $built_query = load_file($filename, $params);

    // dd($built_query);

    return sql_select($built_query['sql'], $built_query['built_params']);
}
