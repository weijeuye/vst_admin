<!--查询结果-->
<#if resultPage??>
    <div id="diaShadow" class="dialog-shade" style="display: none"></div>
    <div id="diaPrompt" class="dialog" style="width: 300px; height: 150px; left: 320px; top: 285px;display: none;">
        <div class="dialog-title">绑定其他活动产品</div>
        <div class="dialog-content" style="width: 218px;margin: 20px auto;">
            <label>
                输入活动ID：<input id="diaActivityId" type="text" placeholder="请输入活动ID"/>
            </label>
            <div id="digWarn" style="color:red;opacity: 0">活动ID只能是数字</div>
            <div style="width: 150px;margin: 10px auto;">
                <a id="diaYes" class="btn btn-primary">确定</a>
                <a id="diaNo" class="btn btn-primary">关闭</a>
            </div>
        </div>
        <div id="diaClose" class="dialog-close">×</div>
    </div>
	<div class="boundCheck_result" id="boundCheck_result">
        <div class="Unbundling">
            <!--<input type="checkbox" class="verticalMiddle JS_allChecked" id="JS_allChecked1"/>全部产品-->
            <a class="btn btn-primary" id="bindActivityProducts">绑定其他活动产品</a>
            <a class="btn btn-primary btn-unbound JS_allbound">绑定</a>
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
						<td class="text-center"><input type="checkbox" class="verticalMiddle"/ data-productId="${products.productId}"></td>
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
								<a class="product-link text-danger JS_boundProduct" data-productId="${products.productId}">绑定</a>
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
	<div class="check_nodata">
		<div class="hint mb10">
			<span class="icon icon-big icon-info icon_bigflow"></span>
			VST没办法查找到相应产品，换个条件试试？
		</div>
	</div>
</#if>
<#include "/base/foot.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<script type="text/javascript">
	var bindSucDialog;
	$(function(){
		var descId = ${descId};
		$(".pages_go").hide();
        bound();
        function bound(){
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
            //绑定按钮
            $('.JS_allbound').click(function(){
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
                        content:"请选择产品后再点击此绑定按钮!"
                    });
                }
                else
                {
					var check = $('#JS_allChecked1').attr('checked');
                	var url;
                	if(check=='checked'){
                		var $form=$("#searchForm1");
                		url = "/vst_admin/prod/promotion/desc/addAllBind.do?"+$form.serialize()+"&descId="+descId;
                	}else{
                		url = "/vst_admin/prod/promotion/desc/addBind.do?productIds="+productIds.toString()+"&descId="+descId;
                	}
                    bindSucDialog = new xDialog(url,{},{iframe:true,width:570,hight:500});
                    }

            });
            //点击操作栏中的绑定按钮
            $('.JS_boundProduct').click(function(){
            	var productId =$(this).attr('data-productId');
				var productIds=[];
        		productIds.push(productId);
                var url = "/vst_admin/prod/promotion/desc/addBind.do?productIds="+productIds.toString()+"&descId="+descId;
                bindSucDialog = new xDialog(url,{},{iframe:true,width:570,hight:500});
            });
        }
    
	    $("#bindActivityProducts").on('click',function () {
            $("#diaShadow,#diaPrompt").show();
        })

        $("#diaNo,#diaClose").on('click',function () {
            $("#diaShadow,#diaPrompt").hide();
        })

        $("#diaActivityId").on("keyup",function () {
            var inputVal = $(this).val();
            if(/[^\d]/g.test(inputVal)){
                $("#digWarn").css({"opacity":1});
            }else {
                $("#digWarn").css({"opacity":0});
            }
        })
        $("#diaYes").on("click",function(){
            var inputVal = $("#diaActivityId").val();
            if(inputVal && !(/[^\d]/g.test(inputVal))){
                if(descId - inputVal == 0){
                    alert("不能绑定自己!")
                    return;
                }
                $("#diaActivityId").val("");
                $("#diaPrompt,#diaShadow").hide();
                var url = "/vst_admin/prod/promotion/desc/bindActivity.do?currentDescId="+descId+"&sourceDescId="+inputVal;
                bindSucDialog = new xDialog(url,{},{iframe:true,width:570,hight:500});
            }
        })
	})
    $(function(){
    	//分页页面点击
    	$(".PageLink").click(function(){
			var page=0;
			page = $(this).attr('page');
			var url = $(this).parent('div[class="Pages"]').attr('url');
			url += '&page=' + page;
    		$("#resultUnBind").load(url);
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
    		$("#resultUnBind").load(url);
		});
		//分页后一页默认已经实现
    })
</script>