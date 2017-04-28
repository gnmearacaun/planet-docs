<html><head>
		<title>Planet Docs</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
		<link rel="stylesheet" href="assets/css/main.css">
		<!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
		<!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
	</head>
	<body class="">

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Header -->
				<header id="header" class="alt">
				</header>

				<!-- Nav -->
					<nav id="nav" class="alt">
						<ul>
							<li><a href="./index.php" class="active">Home</a></li>
							
							<?php 
							
							if (!isset ($_SESSION)) {
								session_start();
							}
							if (isset($_SESSION["user_id"]) && $_SESSION["user_id"] != ''){ 
								printf("<li><a href=\"./publish.php\" class=\"\">Publish</a></li>");
							    printf("<li><a href=\"./logout.php\" class=\"\">Logout</a></li>");
							} else {
								printf("<li><a href=\"./login.php\" class=\"\">Login</a></li>");
							}
							?>
						
						</ul>
					</nav>

				<!-- Main -->
					<div id="main">

						<!-- Introduction -->
							<section id="intro" class="main">
								<div class="spotlight">
									<div class="content">
										<header class="major">
											<h2>The Home of Planet Docs</h2>
                                            <h4>This is an open source project that aims to produce an interactive web platform to facilitate the proofreading of student theses, dissertations, assignments, research papers alike among students and staff. The main idea behind the website is to allow students to publish their academic documents and get them proofread/reviewed by peers. </h4>
                                            <h2>Explore these recently uploaded tasks:</h2>
										</header>
<?php
              //listing tasks
    try {
        $dbh = new PDO("mysql:host=localhost;dbname=pdocs", "root", "");
		
        $stmt = $dbh->query("SELECT id, title FROM `tasks` WHERE date(`expiry_date`) >= curdate() and `id` not in (select `task_id` from claimed_tasks) order by `published_date` desc");
        
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $id = $row['id'];
            $title = $row['title'];
            //echo "<h2><h2>";
            printf("<h2> <a href=\"./task.php?id=%s\"> %s  </h2>", $id, $title);
        }

    } catch (PDOException $exception) {
        printf("Connection error: %s", $exception->getMessage());
	
    }
?>
									
										
									</div>
									
								</div>
							</section>

						<!-- First Section -->
							

						
							

						<!-- Get Started -->
							

					</div>

				<!-- Footer -->
					<footer id="footer">
						
					</footer>

			</div>

		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/jquery.scrollex.min.js"></script>
			<script src="assets/js/jquery.scrolly.min.js"></script>
			<script src="assets/js/skel.min.js"></script>
			<script src="assets/js/util.js"></script>
			<!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
			<script src="assets/js/main.js"></script>

	
</body></html>
