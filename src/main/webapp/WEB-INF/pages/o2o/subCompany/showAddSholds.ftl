<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <#if relationType?? && relationType?upper_case=='Y'>
		<title>父级合作股东</title>
	<#else>
    	<title>股东方</title>
    </#if>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="add-parent-shareholder my-body">
<div class="filter">
    <form class="filter-form clearfix" id="searchSholdReadOnlyForm" method="post" action="/vst_admin/o2o/subCompany/findReadOnlySholdList.do" >
    	<input type="hidden" name="subCompanyId" value="${subCompanyId}"/>
		<input type="hidden" name="relationType" value="${relationType}"/>
        <div class="col w700">
            <div class="row">
                <div class="col w240">
                    <div class="form-group">
                        <label>
                            <span class="w60 inline-block text-right">股东方</span>
                            <input class="form-control w150" type="text" name="name" <#if shareholder??>value="${shareholder.name!''}"</#if>>
                        </label>
                    </div>
                </div>
                <div class="col w240">
                    <div class="form-group">
                        <label>
                            <span class="w60 inline-block text-right">股东方类型</span>
                            <select name="sholdType" class="form-control w150">
    	 						<option value="">全部</option>
		    					<#list sholdTypes as list>
		                    		<option value=${list.code!''} <#if shareholder!=null && shareholder.sholdType==list.code>selected</#if> >${list.cnName!''}</option>
			                	</#list>
			        		</select>
                        </label>
                    </div>
                </div>
            </div>
        </div>
        <div class="pull-right">
            <a class="btn btn-primary" id="readOnly_shold_button">查询</a>
        </div>
    </form>
</div>
<form method="post" id="bindSubCOSholdForm" style="height:360px">
	<#if subPageParam?? && subPageParam.items?? &&  subPageParam.items?size &gt; 0>
	    <table class="table table-border table_center">
	        <thead>
	            <tr>
	                <th width="60"></th>
	                <th width="180">股东方</th>
	                <th width="150">股东方类型</th>
	                <th width="120">资质</th>
	                <th width="290">备注</th>
	            </tr>
	        </thead>
	        <tbody>
	        	<#list subPageParam.items as shareholder>
		            <tr>
		                <td>
		                    <input type="checkbox" class="sholdChecked" data-id="${shareholder.id}" <#if ids?? && ids?seq_contains(shareholder.id)>checked=checked disabled </#if> />
		                </td>
		                <td>
		                    <div class="w150 text-ellipsis">${shareholder.name!''}</div>
		                </td>
		                <td>
		                	<#if shareholder.sholdType??>
								<#list sholdTypes as list>
						        	<#if shareholder?? && shareholder.sholdType==list.code>${list.cnName!''}</#if>
			                	</#list>
	                		</#if>
                		</td>
		                <td>
							${shareholder.aptitude!''}
						</td>
		                <td>
		                    <div class="w290 text-ellipsis">
								${shareholder.remarks!''}
							</div>
		                </td>
		            </tr>
	            </#list>
	        </tbody>
	    </table>
		<#if subPageParam.items?exists> 
			<div class="page-box" > ${subPageParam.getPagination()}</div> 
		</#if>
			
	<#else>
	    <div class="hint mb10">
	        <span class="icon icon-big icon-info"></span>
	        抱歉，查询暂无数据
	    </div>
    </#if>
    <div class="btn-group text-center">
        <a class="btn btn-primary JS_btn_save">确认选择</a>
    </div>
</form>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script>
$(function() {

    var $document = $(document),
    	$checked = $document.find(".sholdChecked");

    <#if errorMsg??>
    	backstage.alert({
	  		content: "${errorMsg}"
	  	});
    </#if>


	for(var i = 0, len = $checked.length; i < len; ++i) {
		var $item = $($checked[i]),
			$itemId = $($checked[i]).data("id");
		if(window.parent.sholdIds.indexOf($itemId) > -1) {
			$item.attr("checked", "checked");
		}
	}
	
    sholdReadOnlyHandler = function () {
		$("input[name=name]").val( $.trim($("input[name=name]").val()));
		$("#searchSholdReadOnlyForm").submit();
    }
    // 查询股东信息列表
    $document.on("click", "#readOnly_shold_button", sholdReadOnlyHandler);

    $document.on('change',".sholdChecked",function(){
        var $this = $(this),
        	_v = $this.attr("checked"),
        	id = $this.data("id");
        if(!!_v) {
        	window.parent.sholdIds.push(id);
        } else if(window.parent.sholdIds.indexOf(id) > -1){
        	window.parent.sholdIds.splice(window.parent.sholdIds.indexOf(id), 1);
        }
    });

    $document.on('click',".JS_btn_save",function(){
        if (window.parent.sholdIds.length > 0) {
        	$(".JS_btn_save").hide();
        	var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
            backstage.confirm({
            	content: "确定要保存么？",
            	determineCallback: function(){
					var data = {
						"sholdIds": window.parent.sholdIds,
						"subCompanyId": $("input[name='subCompanyId']").val(),
						"relationType": $("input[name='relationType']").val()
					};
					$.ajax({
						url : "/vst_admin/o2o/subCompany/sholdRel.do",
						type : "post",
						data : data,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
								backstage.alert({
					   		  		content: result.message,
					   		  		callback: function () {
					   		  			$(".JS_btn_save").show();
							            <#if relationType?? && relationType?upper_case=='Y'>
											$("#subco_parent_shold", window.parent.parent.document).parent("li").click();
										<#else>
									    	$("#subco_shold", window.parent.parent.document).parent("li").click();
									    </#if>
								        window.parent.subCompanySholdDialog.destroy();
					   		  		}
					   		  	});
							}else {
								backstage.alert({
					   		  		content: result.message,
					   		  		callback: function () {
					   		  			$(".JS_btn_save").show();
					   		  		}
					   		  	});
							}
						},
						error : function(){
							loading.destroy();
							$(".JS_btn_save").show();
						}
					  })
				},
				cancelCallback: function(){
					loading.destroy();
					$(".JS_btn_save").show();
				}
			});
        } else {
        	backstage.alert({
   		  		content: "请先选择股东。"
   		  	});
        }
    });
});
</script>
</body>

</html>