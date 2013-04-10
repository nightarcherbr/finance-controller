<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class MY_Loader extends CI_Loader{
	function __construct(){
		parent::__construct();
		spl_autoload_register( array($this, 'autoloader') );
	}
	
	/**
	 * Custom AUTOLOADER
	 */
	public function autoloader($class)
	{
		$part  = explode('\\', $class);
		$class = array_pop($part);

		// Procura pelo arquivo no APPPATH e nos THIRDY-PARTIES
		$sources = $this->get_package_paths(false);
		$paths = array();
		foreach($sources as $s){
			$paths[] = $s;
			$paths[] = $s.'models/';
			$paths[] = $s.'libraries/';
			$paths[] = $s.'core/';
			$paths[] = $s.'helpers/';
		}

		// Carrega os namespaces dentro da pasta model
		foreach($paths as $p ){
			$file  = $p . strtolower(implode('/', $part) . "/$class") . EXT;
			if (file_exists($file)) require_once($file);
		}
	}
}
?>