<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Controller_Finance extends CI_Controller {
	public function index($aaa = false)
	{
		$this->load->library('authentication');
		
		$this->template->set_partial('menu', 'layouts/menu')->build('main');
	}

	function not_found($error = false){
		echo "NOT FOUND";
		echo $error;
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
