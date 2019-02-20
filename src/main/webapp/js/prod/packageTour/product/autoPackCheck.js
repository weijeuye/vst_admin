//检查被打包产品的信息,目前被打包产品只能是当地游、酒店套餐和自由行，且现在不做有效性和可售性的校验
function checkPackedProduct() {
    //是否是自动打包交通的产品
    var autoPackTraffic = $("input[autopack='auto_pack_traffic']:checked").val();
    //非自动打包的产品，不校验
    if(autoPackTraffic != 'Y'){
        return true;
    }
    //被打包产品的id的input框
    var $packedProductId= $("input[propcode='packed_product_id']");
    if($packedProductId.val() == undefined || $packedProductId.val() == ''){
        alert("请输入被打包产品id");
        return false;
    }

    var packedProductID = $.trim($packedProductId.val());
    var packedProductIDRegular= /^[0-9]*$/;
    if(!packedProductIDRegular.test(packedProductID)){
        alert("被打包产品ID格式错误！");
        return false;
    }

    var categoryCheckResult = false;
    $.ajax({
        url : "/vst_admin/packageTour/prod/product/findCategoryIDFormProductByID.do",
        type : "post",
        dataType : 'json',
        async:false,
        data : {"packedProductID":packedProductID},
        success : function(result) {
            if(result == 16 || result == 17 || result == 18){
                categoryCheckResult = true;
            } else if(result == 0){
                alert("产品" + packedProductID + "不存在，请检查")
            } else {
                alert("被打包产品只支持当地游、酒店套餐和自由行");
            }
        },
        fail : function () {
            alert("查询被打包产品" + packedProductID + "信息时出错");
        }
    });

    return categoryCheckResult;
}