<!DOCTYPE html>
<html>
	<head>
		<title>Finance Manager</title>
		<?= $template['metadata']; ?>
	</head>
	<body>
		<div id="content" class="">
			<div class="content_header">Finance Controller</div>
			<? if(!empty($template['partials']['menu'])): ?>
				<div class="menu"><?= $template['partials']['menu']; ?></div>
			<? endif ?>
			<div class="content"><?= $template['body']; ?></div>
		</div>
	</body>
</html>
