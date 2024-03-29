package com.lvmama.vst.back.utils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.NotFoundException;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.ResourceUtil;

import org.apache.log4j.Logger;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import javax.imageio.ImageIO;
import com.swetake.util.Qrcode;

/**
 * Created by luoweiyi on 14-10-29.
 */
public class TwoDimensionCode {

    private static Logger logger = Logger.getLogger(TwoDimensionCode.class);
    /**
     * 生成二维码(QRCode)图片
     * @param content 存储内容
     * @param imgPath 图片路径
     * @param imgType 图片类型
     * @param size 二维码尺寸
     * @throws WriterException
     */
/*    public static void encoderQRCode(String content, String imgPath, String imgType, int size) {
        try {
            BufferedImage bufImg =  qRCodeCommon(content, imgType, size);

            File imgFile = new File(imgPath);
            // 生成二维码QRCode图片
            ImageIO.write(bufImg, imgType, imgFile);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }*/
    public static void encoderQRCode(String content, String imgPath,
                                     String imgType, int size) {
        Hashtable<EncodeHintType, Object> hints = new Hashtable<EncodeHintType, Object>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.MARGIN, 0);
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        BitMatrix matrix = null;
        File file = new File(imgPath);
        try {
            matrix = new MultiFormatWriter().encode(content,
                    BarcodeFormat.QR_CODE, 300, 300, hints);
        } catch (WriterException e) {
            logger.error(ExceptionFormatUtil.getTrace(e));
            logger.error("二维码生成异常：error1");
        }
        try {
            MatrixToImageWriter.writeToFile(matrix, "png", file);
        } catch (IOException e) {
            logger.error(ExceptionFormatUtil.getTrace(e));
            logger.error("二维码生成异常：error2");
        }
    }

    public static void main(String[] args) {
        String contents = "https://www.baidu.com/";
        String dirPath= ResourceUtil.getResourceFileName("/img/LineQr");
        File dir = new File(dirPath);
        String filePath = "/img/LineQr/11622157.png";
        String imgPath = ResourceUtil.getResourceFileName(filePath);
        File imgFile = new File(imgPath);
        encoderQRCode(contents, imgPath, "png", 7);
    }

    /**
     * 生成二维码(QRCode)图片
     * @param content 存储内容
     * @param output 输出流
     * @param imgType 图片类型
     * @param size 二维码尺寸
     */
    public static void encoderQRCode(String content, OutputStream output, String imgType, int size) {
        try {
            BufferedImage bufImg =  qRCodeCommon(content, imgType, size);
            // 生成二维码QRCode图片
            ImageIO.write(bufImg, imgType, output);
        } catch (Exception e) {
            logger.error(ExceptionFormatUtil.getTrace(e));
        }
    }

    /**
     * 生成二维码(QRCode)图片的公共方法
     * @param content 存储内容
     * @param imgType 图片类型
     * @param size 二维码尺寸
     * @return
     */
    public static BufferedImage qRCodeCommon(String content, String imgType, int size) {
        BufferedImage bufImg = null;
        try {
            Qrcode qrcodeHandler = new Qrcode();
            // 设置二维码排错率，可选L(7%)、M(15%)、Q(25%)、H(30%)，排错率越高可存储的信息越少，但对二维码清晰度的要求越小
            qrcodeHandler.setQrcodeErrorCorrect('L');
            qrcodeHandler.setQrcodeEncodeMode('B');
            // 设置设置二维码尺寸，取值范围1-40，值越大尺寸越大，可存储的信息越大
            qrcodeHandler.setQrcodeVersion(7);
            // 获得内容的字节数组，设置编码格式
            byte[] contentBytes = content.getBytes("utf-8");
            // 图片尺寸
            //int imgSize =20*size;
            int imgSize =300;
            bufImg = new BufferedImage(imgSize, imgSize, BufferedImage.TYPE_INT_RGB);
            Graphics2D gs = bufImg.createGraphics();
            // 设置背景颜色
            gs.setBackground(Color.WHITE);
            gs.clearRect(0, 0, imgSize, imgSize);

            // 设定图像颜色> BLACK
            gs.setColor(Color.BLACK);
            // 设置偏移量，不设置可能导致解析出错
            int pixoff = 2;
            // 输出内容> 二维码
            if (contentBytes.length > 0 && contentBytes.length < 120) {
                boolean[][] codeOut = qrcodeHandler.calQrcode(contentBytes);
                for (int i = 0; i < codeOut.length; i++) {
                    for (int j = 0; j < codeOut.length; j++) {
                        if (codeOut[j][i]) {
                            gs.fillRect(j * 3 + pixoff, i * 3 + pixoff, 3, 3);
                        }
                    }
                }
            } else {
                throw new Exception("QRCode content bytes length = " + contentBytes.length + " not in [0, 800].");
            }
            gs.dispose();
            bufImg.flush();
        } catch (Exception e) {
            logger.error(ExceptionFormatUtil.getTrace(e));
        }
        return bufImg;
    }
    
    /**
	 * 解析二维码 需要导入javase.jar
	 * @param imagePath
	 * @param charset
	 * @return
	 */
	public static String decodeQRCodeImage(String imagePath,String charset){
		BufferedImage image = null;
		try {
			image = ImageIO.read(new File(imagePath));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		
		if (null==image) {
			return null;
		}
		
		BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(new com.google.zxing.client.j2se.BufferedImageLuminanceSource(image)));
		Map<DecodeHintType, String> hints = new HashMap<DecodeHintType, String>();
		hints.put(DecodeHintType.CHARACTER_SET, charset);
		Result result = null;
		
		try {
			result = new MultiFormatReader().decode(bitmap,hints);
			return result.getText();
		} catch (NotFoundException e) {
			e.printStackTrace();
			return null;
		}
		
	}
}
