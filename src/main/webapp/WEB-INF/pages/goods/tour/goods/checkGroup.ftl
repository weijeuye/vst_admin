<script>

	//校验可换升级组互斥
	var checkGroup = function(categoryId, productId, branchCode){
		
		var isPass = true;
		
		//如果是升级或者可换，则先进行检查
		if(branchCode == 'upgrad' || branchCode=='changed_hotel'){
			$.ajax({
				url : '/vst_admin/packageTour/prod/prodbranch/checkProductBranch.do',
				type : "post",
				data : { "branchCode" : branchCode,"productId" : productId , "categoryId" : categoryId},
				async: false,
				success : function(result){
					if(result=='error')
						isPass = false;
				},
				error :function(result){
				
				}
			});
		}
		
		return isPass;
	};
	
</script>