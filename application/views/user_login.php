<form id="user_login" class='form' method="POST" action="<?= site_url('user/auth');?>">
	<fieldset>
		<legend>Login</legend>
		<div>
			<label for="login">Username:</label>
			<input type="text" name="login" />
		</div>

		<div>
			<label for="password">Password:</label>
			<input type="password" name="password" />
			<a href="<?= site_url('user/recover') ?>">Recover Password</a>
		</div>

		<div class="center">
			<input type="submit" value="Entrar" />
			<a href="<?= site_url('user/form'); ?>">New User</a>
		</div>
	</fieldset>
</form>
