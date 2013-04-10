<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Authentication {
	private $CI = null;
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
