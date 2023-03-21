<?php

set_session('user_id', NULL);
set_session('user_name', NULL);
set_session('user_teacher', NULL);

redirect('/pages/login');