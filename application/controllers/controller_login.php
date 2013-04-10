<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

require(APPPATH.'/libraries/SkipAuth.php');
class Controller_Login extends CI_Controller implements SkipAuth {
	public function __construct(){
		parent::__construct();
		$this->load->library('authentication');
		$this->authentication->keep_redirect();
	}

	/**
	 * Exibe o formulário de login
	 */
	public function login(){
		$this->template->build('user_login');
	}
	
	/**
	 * Efetua a autenticação
	 */
	public function auth(){
		$login = $this->input->get_post('login');
		$password  = $this->input->get_post('password');

		$this->load->library('authentication');
		$this->load->helper('url');
		$auth = $this->authentication->login($login, $password);

		if( !empty($auth) ) redirect('login');
		else redirect('/');
	}

	/**
	 * Recupera uma senha perdida
	 */
	public function recover(){
	
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
