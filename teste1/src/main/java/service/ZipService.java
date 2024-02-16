package service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipService {
    public void compactarPasta(File pastaOrigem, String arquivoDestino) throws Exception {
        File[] anexos = pastaOrigem.listFiles();
        validarPastaOrigem(pastaOrigem);

        FileOutputStream fos = new FileOutputStream(arquivoDestino);
        ZipOutputStream zos = new ZipOutputStream(fos);

        Arrays.stream(anexos)
                .parallel()
                .forEach(anexo -> {
                    try {
                        FileInputStream fis = new FileInputStream(anexo);
                        ZipEntry zipEntry = new ZipEntry(anexo.getName());
                        zos.putNextEntry(zipEntry);

                        byte[] bytes = new byte[1500000];
                        int numeroBytes;
                        while((numeroBytes = fis.read(bytes)) >= 0) {
                            zos.write(bytes, 0, numeroBytes);
                        }
                        fis.close();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                });
        zos.close();
        fos.close();
    }


    private void validarPastaOrigem(File pastaOrigem) {
        File[] arquivos = pastaOrigem.listFiles();
        if (arquivos.length == 0) {
            throw new IllegalArgumentException("Arquivos não encontrados" + pastaOrigem.getAbsolutePath());
        }
    }
}
