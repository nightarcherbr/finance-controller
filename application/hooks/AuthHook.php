<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class AuthHook extends CI_Hooks {
	public $CI;

	function __construct()
	{
		parent::__construct();
		$this->CI =& get_instance();
	}

	public function verify($params)
	{
		$routing =& load_class('Router');
		$class  = $routing->fetch_class();
		$method = $routing->fetch_method();

		// Controllers que implementam SkipAuth não precisam de login
		if ( $this->CI instanceof SkipAuth ) return true;

		// Força login
		$this->CI->load->library('Authentication');
		$this->CI->authentication->redirect();
	}
}

?>
