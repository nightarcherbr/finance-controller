<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Authentication {
	private $CI = null;

	/**
	 * Constroi o sistema de autenticação.
	 */
	public function __construct(){
		$this->CI = &get_instance();
		$this->CI->load->database();
		$this->CI->load->library('session');
	}

	/**
	 * Faz a autenticaçaõ
	 */
	public function login($login, $password){
		$user = $this->CI->db->get_where('finance.user', array('login'=>$login))->row();
		if( !empty($user) && $user->login === $login && $user->password === sha1($password) ){
			$this->store($user);
			return $user;
		}else{
			$this->store(null);
			return false;		
		}
	}

	/**
	 * Efetua o logout da aplicação / destroi a sessão corrente
	 */
	public function logout(){
		$this->store(null);
	}

	/**
	 * Armazena os dados de autenticação
	 */
	public function store($user){
		$session = $this->CI->session;
		$session->set_userdata(array('AUTH'=>$user));
	}


	/**
	 * Verifica o login e redireciona o usuário para a pagina correta
	 */
	public function redirect(){
		// Armazena os dados do login para recuperação posterior
		$data = array();
		$data['url'] = current_url() . ( ! empty($_SERVER['QUERY_STRING']) ? '?'.$_SERVER['QUERY_STRING'] : '' );
		$data['post'] = $_POST;
		$data['get'] = $_GET;
		$data['cookie'] = $_COOKIE;
		$data['files'] = $_FILES;

		// Se o usuario não estiver logado
		if( ! $this->is_logged() ){
			// Grava o storage de sessão
			$this->CI->session->set_flashdata('REDIRECT', $data);
			if ( $this->CI->input->is_ajax_request() ) show_error('Não autenticado', 401);
			else redirect('/login');

			die();
		}else{
			// Recupera as informações da sessão da requisição anterior
			$data = $this->CI->session->flashdata('REDIRECT');
			if( !empty($data) ){
				$_POST = array_merge($_POST, $data['post']);
				$_GET = array_merge($_GET, $data['get']);
				$_REQUEST = array_merge($_REQUEST, $data['get'], $data['post'] );
				$_COOKIE = array_merge($_COOKIE, $data['cookie']);
				$_FILES = array_merge($_FILES, $data['files']);
			}
			return $data;
		}
	}

	/**
	 * Mantem os dados da redirect por mais uma página
	 */
	public function keep_redirect(){
		$this->CI->session->keep_flashdata('REDIRECT');
		return $this->CI->session->flashdata('REDIRECT');
	}

	/**
	 * Verifica a autenticação
	 */
	public function is_logged(){
		$userdata = $this->CI->session->userdata('AUTH');
		return !empty($userdata);
	}

	/**
	 * Recupera o ID do usuario
	 */
	public function get_user_id(){
		if( !$this->is_logged() ) return false;
		$userdata = $this->CI->session->userdata('AUTH');
		return $userdata->id_user;
	}
	
	/**
	 * Recupera todos os dados do usuario
	 */
	public function get_user(){
		if( !$this->is_logged() ) return false;
		$userdata = $this->CI->session->userdata('AUTH');
		return $userdata;
	}
}
