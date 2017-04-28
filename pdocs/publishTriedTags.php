<html><head>
		<title>Planet Docs - Publish a task</title>
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
								printf("<li><a href=\"#first\" class=\"\">Publish</a></li>");
							    printf("<li><a href=\"./logout.php\" class=\"\">Logout</a></li>");
							} else {
								header("location:./login.php");
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
											<h2>Planet Docs</h2>
										</header>

										<h2>Publish a task</h2>
<?php
if (isset($_POST) && count ($_POST) > 0) {
	$id = $_SESSION["user_id"];
	$title = htmlspecialchars(trim($_POST["title"]));
	$tag = htmlspecialchars(trim($_POST["tag"]));
	$description = htmlspecialchars(trim($_POST["description"]));

	if ( $title == '' || $description == '' || $tag == '') { //in case Javascript is disabled.
			printf("<h2> Title, description and 4 tags are required to create a new task</h2>");
		} else {
			$dbh = new PDO("mysql:host=localhost;dbname=pdocs", "root", "");
			$query = "INSERT INTO `tasks` (`id`, `publisher_id`, `title`, `description`, `published_date`, `expiry_date`) VALUES (NULL, :id, :title, :description , NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY) );";
/*
      try {
           $db = new PDO("mysql:host=localhost;dbname=pdocs", 'root', '');
           $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
           $db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
           $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);
       } catch (PDOException $e) {
           die('Cannot connect to mySQL server. Details:'.$e->getMessage());
       }

*/

        if ($_SERVER['REQUEST_METHOD']=='POST' && !empty($_POST['tags'])) {
           foreach (explode(',', $_POST['tags']) as $tag) {
               $tag = trim($tag);
               if (empty($tag)) {
                   continue;
               }
              $stmt->execute();
           }
        }
/*
       foreach ($tags as $key => $value) {
           $stmt = $db_con->prepare("INSERT INTO `tags` SET tag_id = :tagid, tag =  :tag");
           $stmt->execute(array(":taskid" => $insertId, ":tagid" => $value)); 
       }
*/


   	$query = "INSERT INTO `tags` (`tag_id`, `tag`) VALUES (NULL, :tag_id, :tag) );";
			$stmt = $dbh->prepare($query);
        $stmt->bindParam(':tag', $tag);
			$expiryDate =Date('d M Y', strtotime("+15 days"));
			$affectedRows = $stmt->execute(array(':id' => $id, ':title' => $title, ':description' => $description, 'tag' => $tag));
//        $affectedRows = $stmt->execute(array(':id' => $id, ':title' => $title, ':description' => $description, 'tag' => $tag));

			if ($affectedRows > 0) {
					$insertId = $dbh->lastInsertId();
					printf("<h2> Your <a href=\"./task.php?id=%s\">item</a> will soon appear in our website. The advertisement will expire on %s. <br>\n", $insertId, $expiryDate);
      
            }

                                                                                                             
    }
	
  }

?>

										<form method="post">
												Title: 
												<input type="text" name="title"  placeholder="Enter item title" required="required" maxlength="200"/>
												Description: 
												<br>
												<textarea name="description" placeholder="Enter item description" required="required" rows="4" cols="120"/></textarea>
                        4 comma-seperated tags:
												<br>
                        <input type="text" name="tag" placeholder="Enter 4 tags separated by commas" required="required"/>
												<br>
												<ul class="actions">
														<li><input type="submit" value="Submit" class="special"></li>
														<li><input type="reset" value="Reset"></li>
												</ul>
											
												
										</form>
										
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
