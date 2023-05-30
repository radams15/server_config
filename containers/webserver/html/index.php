<html>
	<head>
		<title>TheRhys</title>

		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
		<link rel="stylesheet" href="style.css">

		<?php
			function get_ip($host){
				$host_data = file_get_contents('/etc/hosts');

				$matches = array();

				preg_match_all("/(.*?) $host.*/m", $host_data, $matches, PREG_SET_ORDER, 0);

				return $matches[0][1];
			}

			$urls = array(
				'Cloud' => '/cloud/',
				'Minecraft Map' => '/dynmap',
				'Jellyfin' => '/jellyfin/',
				'Transmission' =>  '/transmission',
				'Sonarr' =>  '/sonarr/',
                                'Radarr' =>  '/radarr/',
                                'Jackett' =>  '/jackett/',
				'Jenkins' => '/jenkins/',
				'Github' => 'https://github.com/radams15',
				'Github (University)' => 'https://github.com/rhys-cyber',
			);
		?>
	</head>


	<body>
		<div class="container">
		<div class="jumbotron">
			<div class="container">
				<h1>Rhys' Home page</h1>
				<h2>Hosted services:</h2>
			</div>
		</div>
		
		<div class="container rounded centered">
			<div class="row">
				<iframe src="https://duckduckgo.com/search.html?width=250&prefill=Search &focus=yes" style="overflow:hidden;margin:0;padding:0;width:308px;height:40px;" frameborder="0"></iframe>
			</div>
		</div>

		<div class="container rounded">
			<div class="row">
				<?php foreach ($urls as $name => $url): ?>
					<button class="btn btn-success btn-large" onclick="window.open('<?=$url?>')">
						<?=$name?>
					</button>
				<?php endforeach?>
			</div>
		</div>

		</div>




		<!-- Optional theme -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">

		<!-- Latest compiled and minified JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

	</body>
</html>
