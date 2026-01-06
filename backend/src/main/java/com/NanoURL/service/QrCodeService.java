package com.NanoURL.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Service
public class QrCodeService {
    
    private static final Logger logger = LoggerFactory.getLogger(QrCodeService.class);
    
    private static final int QR_WIDTH = 300;
    private static final int QR_HEIGHT = 300;
    private static final int BORDER_SIZE = 1;
    
    /**
     * Generate QR code as byte array (PNG format)
     *
     * @param text The text/URL to encode in QR code
     * @return byte array of PNG image
     * @throws WriterException if QR code writing fails
     * @throws IOException if image writing fails
     */
    public byte[] generateQrCode(String text) throws WriterException, IOException {
        return generateQrCode(text, QR_WIDTH, QR_HEIGHT);
    }
    
    /**
     * Generate QR code with custom dimensions
     *
     * @param text The text/URL to encode
     * @param width Width of QR code
     * @param height Height of QR code
     * @return byte array of PNG image
     * @throws WriterException if QR code writing fails
     * @throws IOException if image writing fails
     */
    public byte[] generateQrCode(String text, int width, int height) throws WriterException, IOException {
        try {
            logger.debug("Generating QR code for text: {}", text.substring(0, Math.min(50, text.length())));
            
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
            hints.put(EncodeHintType.MARGIN, BORDER_SIZE);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, hints);
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);
            
            byte[] qrCodeImage = outputStream.toByteArray();
            logger.info("QR code generated successfully. Size: {} bytes", qrCodeImage.length);
            
            return qrCodeImage;
        } catch (WriterException e) {
            logger.error("Error writing QR code: {}", e.getMessage());
            throw e;
        } catch (IOException e) {
            logger.error("Error converting QR code to image: {}", e.getMessage());
            throw e;
        }
    }
    
    /**
     * Generate QR code as Base64 encoded string
     *
     * @param text The text/URL to encode
     * @return Base64 encoded PNG image
     * @throws WriterException if QR code writing fails
     * @throws IOException if image writing fails
     */
    public String generateQrCodeBase64(String text) throws WriterException, IOException {
        byte[] qrCode = generateQrCode(text);
        return java.util.Base64.getEncoder().encodeToString(qrCode);
    }
    
    /**
     * Generate QR code as Data URL (for embedding in HTML)
     *
     * @param text The text/URL to encode
     * @return Data URL string that can be used as image src
     * @throws WriterException if QR code writing fails
     * @throws IOException if image writing fails
     */
    public String generateQrCodeDataUrl(String text) throws WriterException, IOException {
        String base64 = generateQrCodeBase64(text);
        return "data:image/png;base64," + base64;
    }
}
