FROM firejox/archlinux-vim-base:latest

LABEL maintainer="Firejox <firejox@gmail.com>"

ENV UNAME="developer" \
    UHOME="/home/developer" \
    UID="1000" \
    GID="1000" \
    GNAME="developer" \
    SHELL="/bin/bash"

RUN pacman -Sy --needed --noconfirm ruby base-devel git python2 python3

WORKDIR /usr/local/src

RUN git clone https://github.com/universal-ctags/ctags.git && \
    cd ctags && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

RUN groupadd -g ${GID} ${GNAME}
RUN useradd -m -d ${UHOME} -u ${UID} -g ${GID} -s ${SHELL} ${UNAME}
RUN echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${UNAME}

WORKDIR ${UHOME}

RUN git clone --recurse-submodules https://github.com/firejox/vim-settings.git && \
  ln -s vim-settings/.vimrc ${UHOME}/.vimrc && \
  ln -s vim-settings/.vim ${UHOME}/.vim && \
  sudo vim -E -c 'helptags ALL' -c q

RUN mkdir -p "${UHOME}/workspace"

WORKDIR ${UHOME}/workspace

ENTRYPOINT ["/bin/bash"]