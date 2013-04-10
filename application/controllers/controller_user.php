<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Controller_User extends CI_Controller {
	/**
	 * Exibe o formulário de cadastro
	 */
	public function form($id = false){
		$this->template->build('user_form');
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
	 * Grava as alteracoes de um usuario
	 */
	public function save(){
		$username = $this->input->get_post('username');
		try{
		
		}catch(){
		
		}
	}

	/**
	 * Recupera uma senha perdida
	 */
	public function recover(){
	
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
