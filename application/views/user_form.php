<form id="user_form" class='form' method="POST" action="<?= site_url('user/save');?>">
	<input type="hidden">
	<div>
		<label for="name">Name:</label>
		<input type="text" name="username[name]" />
	</div>

	<div>
		<label for="login">Username:</label>
		<input type="text" name="username[login]" />
	</div>

	<fieldset>
		<legend>Passwords</legend>
		<div>
			<label for="password">Password:</label>
			<input type="password" name="username[password]" />
		</div>
		<div>
			<label for="confirmation">Confirmation:</label>
			<input type="password" name="username[confirmation]" />
		</div>
	</fieldset>
	<div class="center">
		<input type="submit" value="Cadastrar" />
	</div>
</form>
