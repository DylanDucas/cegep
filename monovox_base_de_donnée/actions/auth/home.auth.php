<?php

$homeUrl = is_teacher() ? '/pages/teachers/groups' : '/pages/students/grades';

redirect($homeUrl);