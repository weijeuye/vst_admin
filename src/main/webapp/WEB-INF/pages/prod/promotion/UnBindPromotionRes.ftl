<!--查询结果-->
<#if resultPage??>
	<div class="boundCheck_result" id="UnBoundCheck_result">
		<div class="Unbundling">
			<!--<input type="checkbox" class="verticalMiddle JS_allChecked" id="JS_allChecked"/>全部产品-->
			<#if desc.cancelFlag?? && desc.cancelFlag=='N'>
                   <a class="btn btn-primary btn-unbound JS_allUnbound">解绑</a>
            <#else>
            	   <a class="btn btn-primary btn-unbound" disabled="disabled">解绑</a>
            </#if>
		</div>
		<div class="check_result">
			<table class="table table-border">
				<colgroup>
					<col class="w60">
	                <col class="w60">
	                <col class="w320">
	                <col class="w100">
	                <col class="w60">
	                <col class="w60">
	                <col class="w60">
				</colgroup>
				<thead>
				<tr>
					<th><label><input type="checkbox" class="verticalMiddle JS_allCheckeding"/>当前页</label></th>
					<th>产品ID</th>
					<th>产品名称</th>
					<th>产品品类</th>
					<th>是否有效</th>
					<th>是否可售</th>
					<th>操作</th>
				</tr>
				</thead>
				<tbody>
				<#list resultPage.items as products> 
					<tr>
						<td class="text-center"><input type="checkbox" class="verticalMiddle" data-productId="${products.productId}"/></td>
						<td class="text-center">${products.productId}</td>
						<td class="text-left">${products.productName}</td>
						<td class="text-center">${products.bizCategory.categoryName}</td>
						<td class="text-center">
							<span class="text-success">
								<#if products.cancelFlag?? && products.cancelFlag=='Y'>
		                			有效
		                		<#else>
		                			无效
		                		</#if>
							</span>
						</td>
						<td class="text-center">
							<#if products.saleFlag?? && products.saleFlag=='Y'>
			                			是
			                		<#else>
			                			否
			                		</#if>
							</td>
						<td class="text-center">
							<p>
								<#if desc.cancelFlag?? && desc.cancelFlag=='N'>
					                   <a class="product-link text-danger JS_UnboundProduct" data-productId="${products.productId}">解绑</a>
					            <#else>
					            	   <p class="product-link text-danger" data-productId="${products.productId}">解绑</p>
					            </#if>
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
	</div>
<#else>        
	<!--查询无结果-->
	<div class="check_nodata" style="height:400px">
		<div class="hint mb10">
			<span class="icon icon-big icon-info icon_bigflow"></span>
			VST没办法查找到相应产品，换个条件试试？
		</div>
	</div>
</#if>
<script type="text/javascript">
	$(function(){
		var descId = ${descId};
		$(".pages_go").hide();
        Unbound();//当前已绑定产品的js
        function Unbound(){
            //非操作栏的全部产品
            $('.JS_allChecked').click(function(){
                var check=$(this).attr('checked');
                if(check=='checked')
                {
                    $(this).parents('.boundCheck_result').find('.check_result tbody tr,.check_result thead tr').find('input').attr('checked',true);
                }
                else
                {
                    $(this).parents('.boundCheck_result').find('.check_result tbody tr,.check_result thead tr').find('input').removeAttr('checked');
                }
            });
            //选择当前页的全部产品
            $('.JS_allCheckeding').click(function(){
                var check=$(this).attr('checked');
                if(check=='checked')
                {
                    $(this).parents('.boundCheck_result').find('.check_result tbody tr').find('input').attr('checked',true);
                }
                else
                {
                    $(this).parents('.boundCheck_result').find('.check_result tbody tr').find('input').removeAttr('checked');
                }
            });

            $('.check_result tbody .verticalMiddle').click(function(){
                var $this=$(this),
                    $parent=$this.parents('.check_result tbody');
//                    $thisCheck=$this.parents('.check_result thead').find('.verticalMiddle');
                    ReverseBinding($parent);
            });

            function ReverseBinding(parent,thisCheck)
            {
                var flag=0;
                var len=parent.find('tr .verticalMiddle').length;
//                console.log(len);
                  parent.find('tr  .verticalMiddle').each(function(){
//                    console.log($(this).find('.verticalMiddle').attr('checked'));
                      if($(this).attr('checked')=='checked')
                      {
                            flag++;
                      }
                });

                if(flag==len)
                {
                    parent.parents('.check_result').find('thead input').attr('checked',true);
                }
                else
                {
                    parent.parents('.check_result').find('thead input').removeAttr('checked');
                    parent.parents('.boundCheck_result').find('.Unbundling input').removeAttr('checked');
                }
//                console.log(flag,flg,len);
            }




            //解绑按钮
            $('.JS_allUnbound').click(function(){
                var i=0;
                var productIds=[];
                $(this).parents('.boundCheck_result').find('.check_result tbody tr').each(function(){
                    //console.log(index);
                    var $this=$(this);
                    var check=$this.find('input').attr('checked');
                    if(check=='checked')
                    {
                        i++;
                        var productId =$this.find('input').attr('data-productId');
	                    if(productId != null && productId != undefined){
	                    	productIds.push(productId);
	                    }
                    }

                });
                if(i==0)
                {
                    backstage.alert({
                        content:"请选择产品后再点击此解绑按钮!"
                    });
                }
                else
                {	
                	var check = $('#JS_allChecked').attr('checked');
                	var url;
                	if(check=='checked'){
                		var $form=$("#searchForm");
                		url = "/vst_admin/prod/promotion/desc/deleteAllBind.do?"+$form.serialize()+"&descId="+descId;
                	}else{
                		url = "/vst_admin/prod/promotion/desc/deleteBind.do?productIds="+productIds.toString()+"&descId="+descId;
                	}
                    backstage.confirm({
                        content:"确定要执行解绑操作？",
                        determineCallback: function() {
                            $.ajax({
                                url: url,
                                type: "POST",
                                cache: false,
                                success:
                                    function(data){
                                      if(data.code=="success"){
                                      	//刷新页面
                                      	var $div = $('#UnBoundCheck_result .page-box');
				                		var page=0;
						    			if($div.find(".PageSel") != null){
						    				page = $div.find(".PageSel").text();
						    			}else{
						    				var $input=$div.find("input[name='pageNum']");
						    				page = $input.val();
						    			}
				                		var url = $div.find('div[class="Pages"]').attr('url');
										url += '&page=' + page;
							    		$("#resultBind").load(url);
	                		
	                					//弹窗
                                      	var $template = $(".template");
					                    var $addAttach = $template.find(".dialog-boundSuccess").clone();
					                    window.addAttachDialog = backstage.dialog({
					                        title: "",
					                        width: 450,
					                        height:132,
					                        $content: $addAttach,
					                        className: 'dialog-costom'
					                    });
					
					                    var url = "/vst_admin/prod/promotion/desc/deleteBindSuc.do";
					                    var $iframe = $addAttach.find(".iframe-boundSuccess");
					                    $iframe.attr("src", url);
                                      }
//                                    window.parent.dialogViewOrder.destroy();
                                    }
                            })
                        }
                    });
                }

            });
            //点击操作栏中的解绑按钮
            $('.JS_UnboundProduct').click(function(){
           		var productId =$(this).attr('data-productId');
                backstage.confirm({
                    content:"确定要执行解绑操作？",
                    determineCallback: function() {
                    		var productIds=[];
                    		productIds.push(productId);
                            $.ajax({
                                url: "/vst_admin/prod/promotion/desc/deleteBind.do?productIds="+productIds.toString()+"&descId="+descId,
                                type: "POST",
                                cache: false,
                                success:
                                    function(data){
                                      if(data.code=="success"){
                                      	//刷新页面
                                      	var $div = $('#UnBoundCheck_result .page-box');
				                		var page=0;
						    			if($div.find(".PageSel") != null){
						    				page = $div.find(".PageSel").text();
						    			}else{
						    				var $input=$div.find("input[name='pageNum']");
						    				page = $input.val();
						    			}
				                		var url = $div.find('div[class="Pages"]').attr('url');
										url += '&page=' + page;
							    		$("#resultBind").load(url);
	                		
	                					//弹窗
                                      	var $template = $(".template");
					                    var $addAttach = $template.find(".dialog-boundSuccess").clone();
					                    window.addAttachDialog = backstage.dialog({
					                        title: "",
					                        width: 450,
					                        height:132,
					                        $content: $addAttach,
					                        className: 'dialog-costom'
					                    });
					
					                    var url = "/vst_admin/prod/promotion/desc/deleteBindSuc.do";
					                    var $iframe = $addAttach.find(".iframe-boundSuccess");
					                    $iframe.attr("src", url);
                                      }
//                                    window.parent.dialogViewOrder.destroy();
                                    }
                            })
                        }
                });
            });
        }
    })
    $(function(){
    	//分页页面点击
    	$(".PageLink").click(function(){
			var page=0;
			page = $(this).attr('page');
			var url = $(this).parent('div[class="Pages"]').attr('url');
			url += '&page=' + page;
    		$("#resultBind").load(url);
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
    		$("#resultBind").load(url);
		});
		//分页后一页默认已经实现
    })
</script>