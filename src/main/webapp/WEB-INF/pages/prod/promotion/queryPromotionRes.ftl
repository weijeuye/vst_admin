<!--查询结果-->
<#if resultPage??>
	<div class="check_result" id="check_result">
	    <table class="table table-border">
	        <colgroup>
                <col class="w55">
                <col class="w165">
                <col class="w85">
                <col class="w85">
                <col class="w70">
                <col class="w90">
                <col class="w100">
                <col class="w120">
                <col class="w75">
                <col class="w200">
	        </colgroup>
	        <thead>
	        <tr>
	            <th>活动ID</th>
	            <th>活动名称</th>
	            <th>开始展示时间</th>
	            <th>结束展示时间</th>
	            <th>是否有效</th>
	            <th>创建人</th>
	            <th>所属BU</th>
	            <th>显示渠道</th>
	            <th>绑定产品数</th>
	            <th>操作</th>
	        </tr>
	        </thead>
	        <tbody>
	        	<#list resultPage.items as descs> 
		            <tr>
		                <td class="text-center">${descs.descId}</td>
		                <td class="text-center">${descs.descName}</td>
		                <td class="text-center">${descs.descStartTimeStr}</td>
		                <td class="text-center">${descs.descEndTimeStr}</td>
		                <td class="text-center cancelFlag">
		                	<#if descs.cancelFlag?? && descs.cancelFlag=='Y'>
		                	<span class="text-success">
		                		有效
		                	<#else>
		                	<span class="text-danger">
		                		无效
		                	</#if>
		                	</span></td>
		                <td class="text-center">${descs.userName}</td>
		                <td class="text-center">${descs.buName}</td>
		                <td class="text-left">${descs.channelList}</td>
		                <td class="text-center">${descs.productSize}</td>
		                <td class="text-center">
		                    <p>
		                    	<#if descs.cancelFlag?? && descs.cancelFlag=='Y'>
			                		<a class="product-link JS_check_baseInform" data="${descs.descId}">查看</a>
			                	<#else>
			                		<a class="product-link JS_edit_baseInform"  data="${descs.descId}">编辑</a>
			                	</#if>
		                        <a class="product-link JS_bind_baseInform"  data="${descs.descId}">绑定产品</a>
		                        <a class="product-link active_effect" data="${descs.descId}" dataFlag="${descs.cancelFlag}">
		                        	<#if descs.cancelFlag?? && descs.cancelFlag=='Y'>
				                		设为无效
				                	<#else>
				                		设为有效
				                	</#if>
		                        </a>
		                        <a class="product-link JS_show_dialog_operationLog" param='parentId=${descs.descId}&parentType=PROD_PROMOTION&sysName=VST'>操作日志</a>
		                   </p>
		                </td>
		            </tr>
		    	</#list>
	        </tbody>
	    </table>
	    <div class="page-box">
	   		${resultPage.getPagination()}
	    </div>
	</div>
<#else>
	<!--查询无结果-->
	<div class="check_nodata">
	    <div class="hint mb10">
	        <span class="icon icon-big icon-info icon_bigflow"></span>
	        暂无相关活动说明，请重新输入相关条件后查询！
	    </div>
	</div>
    <!--页面结束-->
</#if>
<!--脚本模板开始-->
    <div class="template">
        <!--操作日志-->
        <div class="dialog-operationLog">
            <iframe src="about:blank" class="iframe-operation-log" frameborder="0"></iframe>
        </div>
        <!--基本信息-->
        <div class="dialog-addBaseInformation">
            <iframe src="about:blank" class="iframe-addBaseInformation1" frameborder="0"></iframe>
        </div>
        <!--查看活动-->
        <div class="dialog-checkBaseInformation">
            <iframe src="about:blank" class="iframe-checkBaseInformation" frameborder="0"></iframe>
        </div>
         <!--保存成功-->
	    <div class="dialog-saveSuccess">
	        <iframe src="about:blank" class="iframe-saveSuccess" frameborder="0"></iframe>
	    </div>
	     <!--绑定产品 -->
        <div class="dialog-boundProduct">
            <iframe src="about:blank" class="iframe-boundProduct" frameborder="0"></iframe>
        </div>
   </div>
<script type="text/javascript">
$(function(){
		var $template = $(".template");
        var parent = window.parent;
        
        $(".pages_go").hide();

        var $document = $(document);
    	//查看
	    $(".JS_check_baseInform").click(function(){
	    	var descId = $(this).attr('data');
	        var url = "/vst_admin/prod/promotion/desc/toEdit.do?descId="+descId;
	        new xDialog(url,{},{title:"查看活动",iframe:true,width:1000,hight:730});
	    });
		//修改
	    $(".JS_edit_baseInform").click(function(){
	        var descId = $(this).attr('data');
	        var url = "/vst_admin/prod/promotion/desc/toEdit.do?descId="+descId+"&isEdit=Y";
	        new xDialog(url,{},{title:"修改活动",iframe:true,width:1000,hight:730});
	    });
		//绑定产品
		$(".JS_bind_baseInform").bind("click", function () {
	        var descId = $(this).attr('data');
	        var url = "/vst_admin/prod/promotion/desc/toBind.do?descId="+descId;
	        new xDialog(url,{},{title:"绑定产品",iframe:true,width:1000,hight:730});
    	})
    	//设为有效或无效
		$(".active_effect").bind("click", function () {
			var $this = $(this);
			var descId=$(this).attr('data');
	    	var cancelFlag=$(this).attr('dataFlag');
	    	var flag;
	    	if(cancelFlag=='Y'){
	    		flag='N';
	    	}else{
	    		flag='Y';
	    	}
	    	var url="/vst_admin/prod/promotion/desc/edit.do?descId="+descId+"&cancelFlag="+flag;
	    	$.ajax({
                url: url,
                cache: false,
                dataType : 'json',
                success:
	                function(data){
	                	if(data.code=='success'){
	                		//刷新
	                		var $div = $('#result .page-box');
	                		var page=0;
							page = $div.find(".PageSel").text();
							var url = $div.find('div[class="Pages"]').attr('url');
							url += '&page=' + page;
				    		$("#result").load(url);
	                		//弹窗
		                	backstage.alert({
                       		content:"保存成功"
                       		});
	                	}else{
	                		backstage.alert({
                       		content:"保存失败"
                    });
	                	}
	                    
	                },
                error: function () {
                    backstage.alert({
                        content:"保存失败"
                    });
                }
            })
    	})
    	
    	//操作日志
    	$(".JS_show_dialog_operationLog").bind("click", function () {
	    	var param=$(this).attr('param');
            new xDialog("/lvmm_log/bizLog/showVersatileLogList?"+param,{},{title:"日志详情页",iframe:true,width:890,hight:500,scrolling:"yes"});
    	})
    	
    	//分页页面点击
    	$(".PageLink").click(function(){
			var page=0;
			page = $(this).attr('page');
			var url = $(this).parent('div[class="Pages"]').attr('url');
			url += '&page=' + page;
    		$("#result").load(url);
		});
		//分页前一页点击
    	$(".PrevPage").click(function(){
			var page=$('span[class="PageSel"]').text();
			page = page-1;
			if(page < 1){
				return;
			}
			var url = $(this).parent('div[class="Pages"]').attr('url');
			url += '&page=' + page;
    		$("#result").load(url);
		});
		//分页后一页默认已经实现
    })
    
</script>