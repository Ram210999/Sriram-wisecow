FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y netcat-openbsd cowsay fortune-mod && \
    rm -rf /var/lib/apt/lists/*
ENV PATH="/usr/games:${PATH}"
COPY wisecow.sh /usr/local/bin/wisecow.sh
RUN chmod +x /usr/local/bin/wisecow.sh
EXPOSE 4499
CMD ["/usr/local/bin/wisecow.sh"]

